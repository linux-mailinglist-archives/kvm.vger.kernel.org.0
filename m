Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC136A4A3C
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjB0Srh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjB0Srf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:47:35 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C120D1D;
        Mon, 27 Feb 2023 10:47:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RziHZjuERSrIT3e8jm9lL9trQzzt6PRKADn2nWu46V9UlvraEHTGtRnLj88iCmlfSb8hH7gFras/3Q9+JEv2fq0OX3hpX9QcQ3qHkaUx/oEN0FVXwbxuCs0ShUJ1PF5ZhwS19Nus64ctw8scgC3fd8OOJC62+XvaVqxbxyJm2YqMrqF9UsxI7Z1VNn6yDykyTkMpOLGPY5sjkYIIJe7xR5tjyYJ6h6cD6HGx9tCgI53p66pcjS5wb0J87uWsgob8MK/lLNG9YHkd+YJg+IrU9L5/gk/WARlzdlpFGF3655Fjmk4zLK9oVpA3etIYUJbdi94YY9paXdoNr44Q70w6Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVX7244KpcT+sTzBVd5SCAXt1ev0fkvGMfzOqH2itiQ=;
 b=lDfp4kwoxAXXo2M/Iy5pPd3p/9MTWBFhgFJ3b70Jtb12HOCYSUAtY5NytR5Owsan9+1JShkOK6Vj5JM85T1DXGxNBBPgJ7jBr3oYNQDINBysmEQOU3lbtfec0jjTTt8yeEdPDcOGEmqeivQeAVkItDDBnnkKMx47MlPEaz4vuoxNjqH1NWkI6xOr933LhE2jBmONoXaE2ciaJDGTDtcB6jvpQ9SbnfDGBwsUBv0CPAMrU0XzZjw6vX/1GBUXkOOG9tY08A56C8N/vV+eR+Qua1jd2nZ31lYlVw/t8GCjFkOkNkxtcNFupk8g0mQTMaDZB3yGxB462XnwYjIxSRrV+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVX7244KpcT+sTzBVd5SCAXt1ev0fkvGMfzOqH2itiQ=;
 b=dsOLapVGKn1TPnG1SsUEdQ+FMyADbYh/Kl4H7MjWyvkK0IqzfkC8hGbMV6vwWo0VhuLR06cHjoqySWWPtubV7N4HyLdJLwTMwIxB4Zo9Um8E2qDRJ/2QFaFjql+0fxtlbbqzllntesL7gBGPeIX2b/Ngu0C3Une6vz2kEuAW6Htf0a2EOCZrIE2kyHVs9lghpkHYTSxXyOn/AyGOwGGS/H0dUrvyvtYW0gpWpoauiKmi9H2KeRu/tin7LnRQlZ9lE64f3C+nBi0Htgx/lTYixp2D03+4QDe0Xx5eSuDV+RGMOEI/H5cibDDZEzznH92ipSGmsgBWsTQyX8sAl5qNaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 18:47:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:47:30 +0000
Date:   Mon, 27 Feb 2023 14:47:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 05/19] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y/z6wX4S73+HIyDi@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: f770eba5-bab5-4361-2bf6-08db18f314a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PG+MBbFjKavnqGOZuxswvNsJvdoctJfkFd6e9+ZwojD/yrvsTJzWj4TfVjiu2vJMxipmm/NfMdp0bBdL1cdd5wODPmUk6y3R1qrVIu/oshXEnPaMN8gnYmmey/JzGg+EguV1CT9ED9KNma94PzC+ZzF8gPt6iUH5Epqt/OeG088hF4ofNmlhcBQct0MDrn1RqdBdl/l7iQQVJrRerCRFn+YbwZykMIdOa1i29Ka7M3Y4QJzcHwI+oLfHQey50JnXXBJhlvuQPKo44W3hTN+Zkansd8mN5qTQlHURxnf0S37pWgdesVeE/4uM+iTMBK/tvlNMCHA8bKEOe1dWsvubn/I0CRpilpV85DI+mZo5tZ/KM6Cl8+exqBB7Ns32ycZslUX/Qx79696LhWG/vTMh9dCDAQynJqBjlF5IEIOFSp3gVReV8PsN2aL6MZolBck1rX1FAPUextCugENW8qKDSockiCBHaFde8Ws7LfGtsvi+UWEBgUWe7YSFSTwRI8tMKYzScJs6nSdUV8plBR81DzuaaQMEPyQqjizbUUgD3DhRSU58ev3tkSkjOUIthSIuSbC2gLKVfmjNcTAXgpWgzMBfz+v8AoT/0wUagu/pdtpcKe/WFre26P/WUZkg0UWuy+hczpGEX9LWc2MIXR4lEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199018)(4326008)(83380400001)(2616005)(38100700002)(8936002)(4744005)(7416002)(6512007)(41300700001)(2906002)(5660300002)(6506007)(26005)(186003)(316002)(86362001)(478600001)(6916009)(6486002)(8676002)(66946007)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yIR/tHKsZN1CAq8wSYpt3Mm026Z1MN2iFI3aDC9m3GrDStVAtgamEKF4qUxk?=
 =?us-ascii?Q?z6LHdPCEzQC6pEsoTVKFxNcb4u0WSpkMq5IpTog9noOhlsU90zEgwoh+Zbeu?=
 =?us-ascii?Q?Q6rB5QZyoE5TNKvQwMZtEpHJ0O/4ZoEgJ0Lhll2o7XEq+BfyUOX0cXF65yTM?=
 =?us-ascii?Q?zGmhd8ITwrG/rgDKwIYUb5PRCbn/fjs/JFiHqfcPd2DZ7Anlr9CVGWUVWhcw?=
 =?us-ascii?Q?XJ6v7Vvbgl5loH70SAKq/ig4fE/YRCn2Jl9ncFyh+0BDtgxDHwSQjHuoJWNP?=
 =?us-ascii?Q?1M5z1vmC1KTRA9uzD2oNZX2IJOEq2CBZnKJ2TmDiFQmQEMsSMPKA8ZBvYJ7x?=
 =?us-ascii?Q?JcCNYXvIpguiXLe/vv7U4XWgXRtZb6xTUoAtQEr9GdeGZIFETvLZSbdKanii?=
 =?us-ascii?Q?NKIq+CRgG/d8+B92PAUC0SSat/pUtUr5ROvFi9ru8lyQhZdT+twmLxjSyPka?=
 =?us-ascii?Q?3zwM4VIvXOyZNjpJ0HUAYpRBxfnL7SrHcIFtlXgwk0UPDHgdrh/eprPg6ioU?=
 =?us-ascii?Q?OWfj8NwQqtKoG1st3sRftV5cYJ27ciRRho4O9j0iq9Geu9HIMNJDv4Ebu4Ps?=
 =?us-ascii?Q?l4ZIw93OQi9FaO1FUkbbensaRP5EpwjpZcVGV2/y30PAaiUARVWREuoLZsvE?=
 =?us-ascii?Q?FWxEFvZ4NaTTLq5s/d/SawpTkmt+s3aNDSSgkodONNp4AzgOGTFddgRW4q/F?=
 =?us-ascii?Q?HOrHfdTjpQRY7/Tv9rSobRadlEcqvcWpVEM5GxzXWTDJUi+FvLj8J0IVayYx?=
 =?us-ascii?Q?jqFGBopb0VALQZRrdhqUC3G+SIqxYvnjJT9cr20MIdStjUIHw5Xz+Mbj9qqU?=
 =?us-ascii?Q?2EP3Xa1XFNnE5Q0ZqeiFDe724QSOyQebHAcEDJzMGQIK8I1lZ+s6lbDwKTPm?=
 =?us-ascii?Q?fyFeLwzalLE31ba1R/hQU0fJnp2iR9zYpsnwdzjxIkmtrF+b+xH8QxVV6qhx?=
 =?us-ascii?Q?sx9nbvO01XVYwX1VoL2XvuqYg68b8N09a7v44dg47WcT57ZdEqJVz6sehBhT?=
 =?us-ascii?Q?Yf1+rVWq4mnT4wXRu/S7+iJxMPY+bEtwLoR5Ask1EEwNUWAmU6YThrC+DH2k?=
 =?us-ascii?Q?MFRZrEJJf7h/OPo6BmyUUGGj7CGQWowpy3aveLj7eK5T1Q5GZHFJO56vWbvw?=
 =?us-ascii?Q?qevl76TIPWuS9xDhFuWwfDWyvm3zUE0ryhqDkcJ1t3KkZy0/E7fJCbFD3SfK?=
 =?us-ascii?Q?9R5fwbb8cfdQ55ZWbORVXy+buTeZPIA+Qv+WxPROQebIfw0mn7MdNZURAwWK?=
 =?us-ascii?Q?5V94Lx05qbMxyfqI+EaDVW6WvNdK0HvOEY6KgASFNFl1qh5fhFwXZvH0o+lS?=
 =?us-ascii?Q?VVXQFeRbnf0+IIVoJiId/RFqhLWOL7laPA2662o1OlIUd63fFZayTaXx4/E4?=
 =?us-ascii?Q?jXSdO6l7TwECq6JskYHMO1/u1biw9C3kdFxPlHVrqVP2TJWXuX07YTDhUmPM?=
 =?us-ascii?Q?yOb3ouZAGA7+kTovLdMMK6A8Mb+jtoNBBmlJDGiAjVxZ0LsyjX3HtqrDAqyR?=
 =?us-ascii?Q?rz3YXzrvXLG+E8ETSapDxhMIN4kOmU1WvFXOYFwuezuWevDS+VFKlh8fV9qR?=
 =?us-ascii?Q?Xrh41QZaTtz1PDBdoRs2GUH4mubWYEBITllpIrlE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f770eba5-bab5-4361-2bf6-08db18f314a8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:47:30.7460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RD8pMGKTQ9NvSdVRnoxwcwRp+M28h3PGP+dMaeARkyX6FxgFIcPnDoPSOHTh6BAH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:21AM -0800, Yi Liu wrote:
> This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 52 +++++++++++++++++--------
>  include/uapi/linux/kvm.h                | 16 ++++++--
>  virt/kvm/vfio.c                         | 16 ++++----
>  3 files changed, 55 insertions(+), 29 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
