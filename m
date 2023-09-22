Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED57AB5B7
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjIVQTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjIVQTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:19:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9E499
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXX3558aixpS2aP3ki1CJC3PGKKUqO+oS9a1rWLrDCXPcdFNosGRFPbyr51wcoQTMZF3bUKXhCUJvsNIXqdPZquaXxw/xG5cqGuY6IBLFQSpYMiDAakiMMZ9dhB0VrtHGGhz1OR5RrfeMpm7nop8EyYyCGoxvYq2rBSTn+u2F1nKFRmYXYlA6JI3DJXVaLR9u7bCfxnuD88ae6vxyMIWchXftF+ZjNd+vbXv9CmnA5lzwgJq+heoh5MUNNrNQf53hlysgjiFamTzZ9YYtssGmavMXqfbEPMETZ9EaMo27BnO0KXS8n+TSpFRjL5oamOMknicrPwIBQzUl4BRwktN5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YExzqT9CjhizrZryTQztiT/02VD7WuEQ0zXMfesPK8=;
 b=dRs5VITSeGwCeI5juSy8F0j5motJHfMu631wuWhz1S97csoM7RyPs45zQ15blJN0i5dKg5JIUw//bEgQ+crj9Tf0ssaT3+xoFaW7CZhSgfkKgoaBMUPMiOUO0LUT7ZUpME+JXB9tAU9MUCiO/4fboyZgBX0qE3JLR1lA9Ct+vaq9VvnPX0q3/BnSavE7gJ0/p5nMlxb6S13NkxoLJQFpew8wMXVhndeNx+yk8X6EUGHyvahuDUIUnAXvqrbbUFRyN+JL/ZRo6DrdJRQbif0/4kjia82R4ng/t+ho+erhR/u2d6dgo0fdK1nF5ApGMzIYPUabGoOJtb+sxE3l+VC2dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YExzqT9CjhizrZryTQztiT/02VD7WuEQ0zXMfesPK8=;
 b=WBj/i45uNUxkpNEcNePjKFIJe3K5aB5x9jWASrHOTONwgPXnDOZK26ONPaOWqSTG7hD6Rf4qjRUUMyVwiXM4a9fXElZ/gGGz0ruQg8GIa2QC0W+LCUABKz3FmrMNgQlszaghO2rf9dCgpwJa24V4spCFlQa7PZRq3d72NB5KK0bsK8Cu6zmcz7ipDZ/iAyJz4bOYOrYF3p7H+XnBVZOD2qjtUWa11RZ2+wjTKbmSEhJdmdK7zneyoDe0WkEuiUAnub18d3TBWpteekadFPHCrV/Yj2/EavVarTDLHfxTexQ0MMqKsybloiVNsh6h3Dtds5CwxwLdMGBYp0k3IVZh0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Fri, 22 Sep
 2023 16:19:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 16:19:29 +0000
Date:   Fri, 22 Sep 2023 13:19:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922161928.GS13733@nvidia.com>
References: <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
 <20230922122501.GP13733@nvidia.com>
 <20230922111342-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230922111342-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:208:120::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f5fb64-1a78-4009-6859-08dbbb87b240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCX2IyFgA47mber5fXIQxfAiy3TUDdFQJe1vJMlUJNvaBWHwM5id+/dIJfmrfPM6W24NlCH5CCrl5SpZuE9xUKkLoBoXxAebyT/mE/2IVB9ajb0k9ijqj2cyEsup+394Q51rmbS3iSPju28F8PG0e7IpEpiHnIFAaEU+CSXJwuiQck07g/c0okaz94L9U8AmFI9hFVkbl1ptUFBB2zzOtdb+g4t++QgEmipPwoqZaEYxoKNs0FVSRfgF7XeaXrBMLdeMTc/rvbAj5LerjoHfEWOjVCENZC/YcR8V+qWHb2twQrXfgDhxtiSey80AWaNWOSF2/FN51d4i6eyN/0s99GtgrVEqWeSD0xEZGWsUyJEjgUpZIOo2+Ll+g/chnCgfQNwqiyTOs4auA8TFxrDHAVhBIANLCi1+Vg53nA4Nn/haPVj6sP3PWuy8Je0Jefzc+saJ8JLhYShXhHW9P1zu/EmKqx2mZLpTlcHs31xg6JGmwJ0l/ziwYyLxHajUj1E4yaqGWRJKemfznXYD/xGL/CFZeWeSd3Z/fGnoq5DUJEz1LvtkynicNLu6ukPcmh/W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199024)(1800799009)(186009)(83380400001)(6486002)(53546011)(6506007)(6512007)(36756003)(38100700002)(41300700001)(33656002)(86362001)(6916009)(1076003)(26005)(5660300002)(2906002)(2616005)(478600001)(8936002)(8676002)(4326008)(107886003)(66946007)(66556008)(54906003)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWVNZ0VEZ2lsL3AzY1R6dnJuRjNtOW01SzFtcXZvcTdrelFxaWtkNkxsbHFN?=
 =?utf-8?B?K3JjRHVkcGVvWGZ1MkdEVzgvdmlXbElDZlF1UEVwZ1QvT2VQWklSeDhWcXN2?=
 =?utf-8?B?QXAvZzA1MzFvaS9naVNsSmtUQ2h2enBycHNOUllGc25IQjRCSWhYWGFxVzZu?=
 =?utf-8?B?cXVYTzV0L3pQUTJkbUUvcmI0ZXJnQVhiT2FINjVMTDA5S3haMXduQ0ZHalVR?=
 =?utf-8?B?b3FjM2QzV05XVEwrNmtlM1p4WTdZeVRaTHdiTnRRZzluM2s2cm1vd24rVUF4?=
 =?utf-8?B?cHBYN01RSkJJSmpjUHc3Z25WU1FieFJocHFHWFNhN0cyUHdzaUtGLzZIdTVW?=
 =?utf-8?B?UDhYQng5RVRTM1B6c3ZMYXUxWHo2TmVQL1lyV3dtZGRmQkNObXBEUWp5TkNk?=
 =?utf-8?B?dVBZblB6VDRXZFQzcTBVTUM4UUtnZm5XdXdFZ0pYa2czN0VwWnpqeEdINVF3?=
 =?utf-8?B?Qk92cVBYVFRnUHNWVCtXQXozTzlCd3o4SGNlWVBXWnM0akVmQmNwU3FXWlha?=
 =?utf-8?B?Qys4MC94WEFMaFd1ZmhZbFRsODNRdEk1akN4cTdzN1BBQ2NRcXhjRUMvSXVJ?=
 =?utf-8?B?R0JNY1hNM3kvM2JtT3ZOa2pQdytUZC9qNDlFTE56SmxvbStYMVUzRnNZV0lX?=
 =?utf-8?B?M0Q5eUcxZEIwR0JrZytiTVpQYkpFYXBRMFBxUERndHhFcTRGZExGRFFkajgv?=
 =?utf-8?B?NE5BTzk5eitQYW0vR2VGUjV6eCsyUk01SmsvRkNaTjhndFoxZUZGV1EyUy9y?=
 =?utf-8?B?YXlhc0dGTDV5VFU4b083THhIcVlIMkpjQ0h0MzhXakpjbHlncEdmd2tQMFlx?=
 =?utf-8?B?UzdpcmdOUDNqY2JDU0RUTHM1OEJNL2xEVmNOQmo4Z2lUcTVwNEgwWHB6c3k0?=
 =?utf-8?B?ZWxtamJPQXllWHZKTU0wUjVSeDhzT3JvVnlNS0ppdHVVTzdMRjFtZXFZZVBi?=
 =?utf-8?B?MUJXL0lSQTJLZU8vVzFuOVEvMUw3alRZREduNWRzUkt3OXFleHhOMlhnaUZN?=
 =?utf-8?B?eWpaN3dEWm94VndJNzg1ckpxOUYrcTFEWFRxdmRyTUppdkdCeUJCUXp6T3h6?=
 =?utf-8?B?TXRMenIxTFlZVUlneURCNVBmQmx2UEllU3ZSVWFHWTZRVkdUN0lTQjJ0K3Vo?=
 =?utf-8?B?Wm9mWU85b0RhU004ZjJOQy9MYVdGMkpXb0liMTUzZDFEd0hITmlEb0hBOVJq?=
 =?utf-8?B?QkZNZENXRXhLWGtoME4vQVpGamJoRnhRSUxEeHpnNks2OWVtNGlsRE1OZGZU?=
 =?utf-8?B?WFM5QWI1M2FQNnlGc2k0V3JqcVBKR3l1TEFTclNvK01lUTVJK0JSQWZvaTBx?=
 =?utf-8?B?amkxVkc0a1I4bUxmNG40bjlkZFNCOUw2M0swaVBOSG5YczFPNkREMnY5eUQx?=
 =?utf-8?B?cU1ybEJMVEdESStCV0RXTXhhZjFlSUdPTlpBYnJURVViRmhyMU00My91OFVu?=
 =?utf-8?B?dnpkTUZtUGtWUnl0M0N3SndUOG5LUWpITE1sMHAwQUhQSlIzYlVRKzU3aThY?=
 =?utf-8?B?SmpVN2x0U3gzbFBuQkMrVGdQdWZEcmxpTEpma1VZL1N5dmE5RjZFb3hDa1c4?=
 =?utf-8?B?YnBxdmE0K2EwbDBGOFdWS2tsTWVIY1J4T2RQRTVuMFdHOFJpc3FkRHJuaFpE?=
 =?utf-8?B?MDRGMW1abFM2SXpMRjhLUXFXQjlVN09QU3o4eDMra0h4Q2MrUFBvWDNKTlFF?=
 =?utf-8?B?VzE3aG85cWFVYjVwZjVOVUZNY2psdkxlTHErcjR2WG8rNERKOHNVVkIwZXpa?=
 =?utf-8?B?cXVkZ1NwSXRFZi9tSy9acXlHZnFVK054TlZuTXpYUi9IUU5ZQTFwK3BBbjhL?=
 =?utf-8?B?RGJvMHZ6WnBYMFFjcE9sZVl3SWlrb0NPd25kcFNBcWJ2N2t5WjNuRUpXTWY4?=
 =?utf-8?B?QXZ3eERWcU02YVlnVDBCc0hiTHc4VEwwcjhDTzBUMCs1QmdSUGVobVhMS0Q2?=
 =?utf-8?B?VkVwanBHMWZ2WmVTb1BOODBpOFdxUjBVdWprQ0E4dEhneG1GZWxHQ2g1YlhD?=
 =?utf-8?B?ZWdCY1p4WTFiazZTUGhFdVZpempvQTJzZktxOVppZUpxL3dIQU9VV3ZoZnJn?=
 =?utf-8?B?UGxOKzVwdERDTlBuRERGbkFEejZCa2c5cHh0eisvS1BnM1IwZWNkWkhKQzVM?=
 =?utf-8?Q?I8grLbGJtQvNA1VpNZMYAGSjh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f5fb64-1a78-4009-6859-08dbbb87b240
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 16:19:29.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DX2dresCbp1UynNbdGsBwIJNEW9Qk0UYn43QAeumWfhq7ThDmWdCJbyeSKo8r8Py
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:39:19AM -0400, Michael S. Tsirkin wrote:
> On Fri, Sep 22, 2023 at 09:25:01AM -0300, Jason Gunthorpe wrote:
> > On Fri, Sep 22, 2023 at 11:02:50AM +0800, Jason Wang wrote:
> > > On Fri, Sep 22, 2023 at 3:53 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >
> > > > On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> > > >
> > > > > that's easy/practical.  If instead VDPA gives the same speed with just
> > > > > shadow vq then keeping this hack in vfio seems like less of a problem.
> > > > > Finally if VDPA is faster then maybe you will reconsider using it ;)
> > > >
> > > > It is not all about the speed.
> > > >
> > > > VDPA presents another large and complex software stack in the
> > > > hypervisor that can be eliminated by simply using VFIO.
> > > 
> > > vDPA supports standard virtio devices so how did you define
> > > complexity?
> > 
> > As I said, VFIO is already required for other devices in these VMs. So
> > anything incremental over base-line vfio-pci is complexity to
> > minimize.
> > 
> > Everything vdpa does is either redundant or unnecessary compared to
> > VFIO in these environments.
> > 
> > Jason
> 
> Yes but you know. There are all kind of environments.  I guess you
> consider yours the most mainstream and important, and are sure it will
> always stay like this.  But if there's a driver that does what you need
> then you use that.

Come on, you are the one saying we cannot do things in the best way
possible because you want your way of doing things to be the only way
allowed. Which of us thinks "yours the most mainstream and important" ??

I'm not telling you to throw away VPDA, I'm saying there are
legimitate real world use cases where VFIO is the appropriate
interface, not VDPA.

I want choice, not dogmatic exclusion that there is Only One True Way.

> You really should be explaining what vdpa *does not* do that you
> need.

I think I've done that enough, but if you have been following my
explanation you should see that the entire point of this design is to
allow a virtio device to be created inside a DPU to a specific
detailed specification (eg an AWS virtio-net device, for instance)

The implementation is in the DPU, and only the DPU.

At the end of the day VDPA uses mediation and creates some
RedHat/VDPA/Qemu virtio-net device in the guest. It is emphatically
NOT a perfect recreation of the "AWS virtio-net" we started out with.

It entirely fails to achieve the most important thing it needs to do!

Yishai will rework the series with your remarks, we can look again on
v2, thanks for all the input!

Jason
