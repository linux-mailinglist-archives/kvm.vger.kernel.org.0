Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7437AB211
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjIVMZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjIVMZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:25:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1C799
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:25:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXZdVOMsMgDyV0fR4dqpDFKZjoMU72Cpi1OMrfp4XQotJazyqkBawH3I56hJT+xtRi91xgPFFM4s8gPi9exhfY4w3YQGWYvH/pNPFbCBywRmeI2hLFAaH1rN/HAi8UFzCdJ9zC37GqvxKHCwSZVbQkUqqpU4vyz6irFTywlS/FBirXkJOS/0cJHP2yazunTrobxdPLLBt0Q5J6ncZmX+6HWNhziDJ9zdUj96yDugG8UrgJGX4k7hyuCDbEla0AMbbcgO+I1CEJ+lZ2Qwyuv3feIqbxb//elEEadquvr3QAP9H5WL+WxgzLDeUIA04XD8uNi2IuC/rXY+XkiMTubi3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHBwNODRehSdBdiPZfd5KszgegT7DG1uOtThZ2svH6Y=;
 b=S7nbhBUK5IPVKbvl9bfQsq2QWazxRchae92MIQvF+rgiHVA6i60tOfIJVDZXDqt38pqJ0LjOP+GyMEIYG1S/FO5CmyrLz7OdgW87IgyZphUrxaFcc+PCuFpDZjS6856ZhZClVhd7bmrhbc4ALlmHRKeOd3GZIHvaF+YUPPVP+js+A0uV5Lrnm/9hHURVUfCUqdzgZtCr6Rm7rTuX0boaElv+1Pw6zrGW9lLy1zLYLYGU8P2AOO7XWwgpshcO1MbmpRW7KInXMh5mTHLodpRI26NaYrVS/mHjQc7rUey0KzR/ZweFFYRKquT8psGocqpkF+hxu7LTubdZ88y0IELNEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHBwNODRehSdBdiPZfd5KszgegT7DG1uOtThZ2svH6Y=;
 b=h6aWpt9JA4b5J/MYPRGx4qDNuGTbpkAIHDVHe7gddEyMB/LBRkzyiARC8RHkvmoqJouzCnHhmg4UsyfDCr3p7ri2Q24Vbc6lHkFDTaL6fzwx0YX48CQZ47bBSxP6M8w+kGHrhwMCKNGkkcovIdm6ai8bMzejv/WVHjGKHmlXMvhjeq6x7pqoF1+JMBSwfeLs/PHyR7V5NS8FBRIUSbqwCUw2sAW3nMmHDdKuWRcm29dTDWej3y5MJ/1Wd8OFsUx5Me2cyVeA9oQCWe6JJuxu6LoWSG/CAw0ios7HBs4v8SrwirHtKxAlA9cSqcn47A8aYwPe+B4WG13Kp0n9GwuNpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB8130.namprd12.prod.outlook.com (2603:10b6:806:32e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 22 Sep
 2023 12:25:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 12:25:02 +0000
Date:   Fri, 22 Sep 2023 09:25:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922122501.GP13733@nvidia.com>
References: <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
X-ClientProxiedBy: BL0PR0102CA0048.prod.exchangelabs.com
 (2603:10b6:208:25::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB8130:EE_
X-MS-Office365-Filtering-Correlation-Id: 23cd7cea-358f-4a52-80fc-08dbbb66f1fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrR3w76q1JMmeaGpn3j/bWTJQtjEHBVl3EWUnwugMn80RkTykLkucQ3xPUJZ+LvDmHnB/tPI2Hd0/Py6ya5P5mItHuth+qFJdK/I8DD99/3V76I5p7TaWTFVleUB9d1Hh0AjlZJ//S7n0KKyYl+CBsLOmvjavd7/LrACRdOYcEx1+ztVllTUbnP6WQr/Rqi1N03bJ0MOvioY9sUMxL/eryV6sERoBxYZv+ey71RgYovi4NaOFNgmZB0O1yEd4DdPxnwyuDSNeQyOlvmSRPZkYxcfkv5R3ZaJur+YnAkycj7rJH+VV0tEUqQx6rSotySK7qnCjU0hMiFbe+GygL8BxNRaA0dV1KwW06qjQ9nQvk4NmHRbN7sOdMgogQKZqACsB5oNgZsmPRtKcE83u/3S923kcIdNFBXy9P8YjEwyQPZ9fG3PQdkfdKo5c5edJcQHNjCD6Hy08NUD1xi8JC6UymVm5JSx9+ujaQuJdbj+0IB+Hs4NgBYGWXRBn43/+d7O/Y84pBI0X1tJle3+T4RnNDWGxqDSa81fJzPEy8BFfGdPwjsrUydqmgcBulXynbUG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(1800799009)(451199024)(186009)(2906002)(4744005)(4326008)(5660300002)(8936002)(8676002)(107886003)(41300700001)(1076003)(316002)(66476007)(6916009)(54906003)(6486002)(6506007)(478600001)(66556008)(26005)(6512007)(53546011)(38100700002)(33656002)(86362001)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHIveWJoV2diTkloU2pMUHl1Ym9ZS0tQQnBwbjRLazJCL3habU00cHJpdzNE?=
 =?utf-8?B?R3ZadkFmeGhIS1hkM05SMlQyZTk2U3N4NVNRN2Vsek5QNENXbEVGL3J4TVFI?=
 =?utf-8?B?eGF6MG1JMVVJVXNBMmZ6aHI4NkZSa1V6YUpPMG9yeHdzenZNK0RRc0xqNHNL?=
 =?utf-8?B?VE5MbHlYcjNLNWFWNDZybmlnSzVrNEdtVUNLV3B2cmg1RmY5RVlnVGlsUXRl?=
 =?utf-8?B?N21ieU11dE54NG1mMXlkemFHaS82T1k1OXRoWGZiQmxZUVNoZ1pVNFYzV1Uy?=
 =?utf-8?B?RTdmQkcyaldQYStZVWdNK1JTVXEwQitmUWtpaWlLd1dSV2pjcGhXR1lYM1ha?=
 =?utf-8?B?UUJpcXlWUmVucUJ6cjRpNW9iVHhwdTVaVDVLRERwbi8vZUhxK3BWeW9NN3pZ?=
 =?utf-8?B?WXRwNWVRejl5bE0wUDhsVjM1clNLaHZtcnl4bjJiSFdiL09IeTdtTDlKeXFv?=
 =?utf-8?B?UXBtTlJ4QlU1VFBJUUo4Rjl4TkZwOFcrcUtJcmM2R0o1bzNiU0V6eGU2dzRn?=
 =?utf-8?B?TlZ1c1JVVlU3QnRxZkxUZHdmSWc2cVE2SUNWYmZ4eTF0T05tZVd1cmJ5a0Ro?=
 =?utf-8?B?Ry82QnYyWEM3T1ZMYUlTL2E4THByYTYxQVpLV0ZQZTQvREJlVDVxNUJwMDky?=
 =?utf-8?B?L2pKVjhLZmdGRkwxUnJ5YUhVTVp3c3VSL0hEdEdWS3VscTR5bEJ5UUxXeElL?=
 =?utf-8?B?RXYyQjM3dG8rQWxiYXpiOVBOd3VBcE1jVlJZRERZZW5TSGpGNFo0VnZsZkdj?=
 =?utf-8?B?S2dSNmJKZ1BNTG1YTDZ0dGhzbmZYczI5dHVsdGprVmk5ZzBGTlczNUYwS2R2?=
 =?utf-8?B?QzhIdTdwQVZURzJUUEJ4WHlIM2k3UTU3cDNmQWp6bURyUktGVnA2LzNhN3Nx?=
 =?utf-8?B?K3B5NDRtMVBuS2JLWEp1Nzh4cnVTSk9IYzBtcnRVcDVrYTIwSk50MHNNcFo0?=
 =?utf-8?B?eFBONk0rdjh5RUhNZCtFOTV5TDU5UkdUL0NrOVY5cEZ3WVFXUU5ITmF4N2Ex?=
 =?utf-8?B?d0lYUllNcmNXRWxhV21PaDFIM3lsc2hFOHN0UEtwWFdxbGo4b0NNWEFXUXBw?=
 =?utf-8?B?akhsMlpIdU84RSt5NzlJeVE5OXJGemx5RitKU3RoL0xOYWVnTm9hcUplZElQ?=
 =?utf-8?B?djUwOG55VSt1amFOS2FBbHJRNFAyd25DOC9jaVY3cjZ2SXc1LzdYUURoL1BL?=
 =?utf-8?B?N1V0MkN4RDdjbmFYUlFyM24xRzRkQTZFVy9NYW92ZWYzSkd0cytQYm1QOEFk?=
 =?utf-8?B?NGJ0Zy9IYVRzcUFtdlVITmxYRjhOU1dPZ0o4WDN3bU1iU1QwYzlaYWd4OTE1?=
 =?utf-8?B?bS9kdGE2clc0TUNnTHZDSnBaUklpeHVEV1d3TTVBdlBZTWt4NDVyZHc0MTlB?=
 =?utf-8?B?WGI2V1BJdTJEbGg5WlU2ZVFCdlZTSUh5NzBvbU53Tm9NQ2VseE04SXU0Mjcx?=
 =?utf-8?B?Mi9CbUZ0OXhreGlXSDhnOWlabWNFZlIzdW83MGV3RlV3cTJlMVZ5M1lybjBY?=
 =?utf-8?B?Tk9keVU1ZDNmb2VvRHZaVzY0WEpxYXBsdFFLdUlkZnp0cHJOaVEwa1dMaUhu?=
 =?utf-8?B?RHhqcVA4R2dmVkp5ektoS1lIL2Y2SVRURFIweHQvcGhXQVpZa3VXbDhFb1dw?=
 =?utf-8?B?dndpN1BFZ0F2VUc4bk9IUUZlem1vMURKcTZaM3A0bEFzUFZGMzFrNmcrZldC?=
 =?utf-8?B?VkVzNXh4QzhUUFJrNDhGL0VxTm9SYTIvd25VSU0zVWFVZ09lTzQvTkM0SFoz?=
 =?utf-8?B?a3BLbnNjWTZFbDN0QytrVWxkUGNubHpTQksrOHd0bERwcXdxb2FINWhIaWRM?=
 =?utf-8?B?R09PMTFFUjNSaTZ4eGxJYmgrenhuT08wYUl0ZFJDcmlkQzg4dmUwOU1qL2Rh?=
 =?utf-8?B?MjBLbXkybXFEQjFJNFZBY3hHU2wvRCtlT0JhOGE4VFE1N1Nxc0tySklrZEow?=
 =?utf-8?B?UWxTMStQWjVkeFJwOTRsM1psM2RKZzVOSmt3ak52UWVrODRFMENyZXdpZEIw?=
 =?utf-8?B?QzQvRzlhRGRtNjMzbHJFdlcyVjFaQnJyUGtyQUlheVl6OWNMZ1JqNmc0MDV4?=
 =?utf-8?B?eWRFbmgzcERNTVhMSUxjY1ZnZ0lKcWJlUmgzZGdHTGNsSEdQdGxiTk9hV2s3?=
 =?utf-8?Q?Tk1Z4nKXX6fdIUGZjWoimlIFL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cd7cea-358f-4a52-80fc-08dbbb66f1fa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 12:25:02.5164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKAmKV2moiZq0+512V6HGyV/PQR2zGVLpjUA+k6oFB0hfHKFGRyV1qt9zOn4UAJQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:02:50AM +0800, Jason Wang wrote:
> On Fri, Sep 22, 2023 at 3:53 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> >
> > > that's easy/practical.  If instead VDPA gives the same speed with just
> > > shadow vq then keeping this hack in vfio seems like less of a problem.
> > > Finally if VDPA is faster then maybe you will reconsider using it ;)
> >
> > It is not all about the speed.
> >
> > VDPA presents another large and complex software stack in the
> > hypervisor that can be eliminated by simply using VFIO.
> 
> vDPA supports standard virtio devices so how did you define
> complexity?

As I said, VFIO is already required for other devices in these VMs. So
anything incremental over base-line vfio-pci is complexity to
minimize.

Everything vdpa does is either redundant or unnecessary compared to
VFIO in these environments.

Jason
