Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0BC4C971E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiCAUkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 15:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiCAUkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 15:40:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BB50479;
        Tue,  1 Mar 2022 12:39:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SB/BmV8T4RbGn2loeCPXDBUd2TakRwfSJw58GaUHoZyt+AN8djqD6TxVDmuTg69DEhaNq4NKEKAwp3WFSsA9GhzBvFkV6RFfFfMgKQSncc9khGVjxcLyv4OHaDeTC6Zq3nwzckkDIwpc+sfRHIKMYyq9K3vAedNi6JfhcxPbn5h7So7h+/uQyciYLuy7334Nphy99G8zwfzGxrqa8N4u8pPxfjT+2ZMSq2XkA1L6Tk08UA8z10KYiJW/CYhSVBSJhatesQJyKGNSm/9iMwGACIcx5s79bnrgwnRcPv5lsqn815eAzR9zFzboXM02tnUQSC04pfT0+OlNRNHZxBvmGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hh/f+ozUoxYSkvWpS/Bl7QDmi9TfoFq9q+GsyZnTRd4=;
 b=QM3zKAf/86yiNMUmSkc13FF2BIOeW3Dh+up5iY9GZB/QFaNriMRtV0PbTTLznT19hRr/bY0/WYv9+73zYdknoy4Ha6cCDuDSgf7+2XzT1xWqzXQjA1lJ0VwGk2y0B9EchH1qNdENy0UNEFftID7Ghs3HSViVCdysQxxOqFsXEnFplYAgjITM5Mvy95/BT9M3DcWz8pVIVywwAgQZ50AF8fCpbcOPGUEHazcwMTUrTxk5iwPSffNYC942enxJVvv48VL0AO6JpNv2gQX4Czg3RVeNv0qFcCu/lnvFKcOKAHr0B//SS699ZpFgB2uNTmBbuv24jV7E4gw0Y4KV/pbcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hh/f+ozUoxYSkvWpS/Bl7QDmi9TfoFq9q+GsyZnTRd4=;
 b=NXL2/VZMCHC4lOIMgx1KORDeSQPtEgZ//1ZNr4ksUHMLH58Ghrla33LZw/QwCIv+HCtClymKlSPHZzUcBUACY2eZON538Y02j9KxhXRmec4oVxuWki4lXY3wiy8MM2I9cjDxp8hceZ41DCNt7UPV3zUCRPuOltBC2Lg95XKOKZ5YbGwr5/Ai3TyKox5tC9dyTJEFfyXON/tJf7fO4Odvjfq+eyG/uX9UXISEWVGhf7LSkPOfzb3qB1xB9c2/8qV40pc7buDxz2AN6szXSkK1irZVIWlnDkl5IfRlPpqSGbEZm3/HpOgGgCiytuwhSTnKcWvvufTSWfHXZq7ydXMrxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB5516.namprd12.prod.outlook.com (2603:10b6:610:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 1 Mar
 2022 20:39:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.014; Tue, 1 Mar 2022
 20:39:39 +0000
Date:   Tue, 1 Mar 2022 16:39:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220301203938.GY219866@nvidia.com>
References: <20220228145731.GH219866@nvidia.com>
 <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
 <20220228180520.GO219866@nvidia.com>
 <20220228131614.27ad37dc.alex.williamson@redhat.com>
 <20220228202919.GP219866@nvidia.com>
 <20220228142034.024e7be6.alex.williamson@redhat.com>
 <20220228234709.GV219866@nvidia.com>
 <20220228214110.4deb551f.alex.williamson@redhat.com>
 <20220301131528.GW219866@nvidia.com>
 <20220301123047.1171c730.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301123047.1171c730.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0279.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09622560-15b3-4e3f-a3f3-08d9fbc39b6e
X-MS-TrafficTypeDiagnostic: CH2PR12MB5516:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB55169085D4B7C83BCCDF98C8C2029@CH2PR12MB5516.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLNtPXVSJVh68YU1GKwe0s33WZuhEJ8onvoOJuCfxM+oFwEYEcroLOrQjo20JdL3tFUwgZqfNehqOSjGJEdnVQUE0fjofpJogRVWUAp9YcV0jH0uYttKaR1PqiqI6MKO0treN3487oRn83T8Pat/t0PEF6HazPhI3RC/1ig/IhHniFMWiItBcHqk2fKnX0dig4megYh/mkrS/ri0VE7Kyig43vzE6fpFoUgotr9KnOyP44aA3bDVOrqw/XRUrTr/Ua+JttFU7R1Dv6ZDwCaKgFE34xRlaMLDd+JD8EZNnjKSzXm3Xj4kZ9JEor/qW/QErrhsc8Qm3LtOWp78rDPGbt2xUTO60RpiozxX4nSYzcfrx9xrmcBlqcTj5hRzhiD1GzMvLsjtFBG+GOOBFWk4+NmVH0w90xb3vXwos7vzReYlESGHinbr1vPb53eNgHRpTxIE75ru1f9SfzKuzbqS6F5I3rCJF26vc4vUltB6manBcYIJEfzCLKZ59fcg3lkye/jl0UzY9W0ZReL5Qrr7OBRxtg3dpwbX5aXI+xE76GtM8sQufLFEKciuoTkr6yfxVMO0VPooaA+V8VhU9xqQjVH0qXvFBFdnZuZvootfLi5zcl0Zh3V1fnMBzSmUzCD3bmNSEYrQP5NuhLOfGw0SFyTPgVE/QlVK33vcKZ/U/hLFS8yVVuLhJAQetexpfbga
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(86362001)(8936002)(8676002)(4326008)(66476007)(66556008)(66946007)(2906002)(508600001)(6486002)(5660300002)(7416002)(38100700002)(6916009)(316002)(6506007)(83380400001)(6512007)(54906003)(1076003)(2616005)(26005)(33656002)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KYmJ/UnMKTPOOTCQjdvSDLy52SFgfART8tDWEMYhjsYKqJbrzHspC+DqiMmG?=
 =?us-ascii?Q?3UpUq73FCiAPUPD0qqsbbm2lY2Bv+CoWfv5kGXwlpauErT3x8uJ57AcOXvP7?=
 =?us-ascii?Q?/tSL9xaUR+jFipvg0AIN5epnOSYuvj0pKxl6JytxBdXYY8UOYrdS4GtqtBQC?=
 =?us-ascii?Q?XyyE1yY2Vmr4pxSEl/RPeSk1r1CEbUYrDOtRRLMBHxh1qJUMuAGKjvOsneTp?=
 =?us-ascii?Q?/gKsf64nWLu4dqeIMUVKrCxMTTSBjvm3VsVBh+2eSrVL5ivystXYN2iMDIuc?=
 =?us-ascii?Q?HLVs6u9wvwshdaIt/OZP4YxY9Crebfzzj8HTXYIgCgNde1W2iApRgiUpvt2W?=
 =?us-ascii?Q?Wnd+GvA8xuptYWPKU143lBur8b9IouzAt/uSSwg3NhxGPPRATvKq4ELyvldV?=
 =?us-ascii?Q?SEuOoqt9UtubGywP8vgDGP9rRg9v1cMiCzArPd1az8ASGtJX5nwA9Tqg3QqT?=
 =?us-ascii?Q?Nhux7duW3CgPeV/ghjEPKBcFYv8x5OEgoQ5WO0dUnppXl8bSYsEYb7eFrPwB?=
 =?us-ascii?Q?UvxvrkWAscWDzN3dn4FYZPKK0mo5Ex6ie37mHFKQOfdQ9Dv8iqR3QdGKnjHH?=
 =?us-ascii?Q?JykWfim+9oiPgyyXAYXnuYXw0Vo0OVKl052WeG/mc51Vk/rOjF0hp+KYMfPS?=
 =?us-ascii?Q?YJWAQMlCfP4mNRGPkX5Wgg7bGC4LJxY50fMtZwJZKixMe8xjqZPeKrucs/37?=
 =?us-ascii?Q?ZapVAYEg9fkkXqZqXiWxN6PbeLAwfsoCY4jH0MEwjl2+nM6wmaQWJ0m4JNbe?=
 =?us-ascii?Q?YQkpUSqdAdSZ446mODsmS//ttRQbl/aHgPw83fvrQPszXK/oowu/PScdG1A9?=
 =?us-ascii?Q?dmj2POwku1F9RZpD8xMj5i1ZKLOufeZWO2823Vgxgg492WZur8EuXQABklS9?=
 =?us-ascii?Q?i8jwyvqLX/4PqaO9R5ysLFSLqkL2aK/QdK5Qdg+T4QwFmqdy7TPoNeddpOq/?=
 =?us-ascii?Q?a6dATSeCsgNBef8TUlXGA9qkM8dAY/V3uzSqxU8JSegNpT/sGbL+1r+BwAzh?=
 =?us-ascii?Q?OzMQNt56RSwp0vkAHsBLpvzLFhNoFrJ2T9NnM9bBqjrHwwxFPDDh+wjswlvf?=
 =?us-ascii?Q?eRbUUIYEDzmuSXWdQPTQVGD2MBH4kDZ28d/cehXYi9hqh3/W3JhMF/wUTU8f?=
 =?us-ascii?Q?fBsVaxFFm0D/Iueg9huJcd6fQ/3dmaKwbrVmszdVnimAHiwmbpIXF3Mohf7e?=
 =?us-ascii?Q?lRGaUsdlDchfNQbQ8E9sbYcdptCM1FtFJ7VzVxRRYj3ospDMW3RIMY7fKt+R?=
 =?us-ascii?Q?yZoIvn5/EWBRIH20LSbamUWjxsxUBPAmRu0aK+lDPXhiuTY9fVeQKu73qOXr?=
 =?us-ascii?Q?eq76S0vdsUJKLP4iZ9yAo+GikTZvkcLCKo6E73YTf9wNkX0NFrGnQm76/Zj3?=
 =?us-ascii?Q?/CEZ+DF0+/M11rHR94lIIxJ/3DB5hNmj1/CVpPkB9bQ0Rm6b9H6vcrNUXVxV?=
 =?us-ascii?Q?uRSelpm9dl/7ve1qer4Y02qYfs7FjfkVDT2ygVOfKSENYPECmECMLoH96e9u?=
 =?us-ascii?Q?vrCFV/YUx1Ujjb4ZWMIag28P88SZsozhz3J/kEueGn4w/9IzkvrRJXKIypPD?=
 =?us-ascii?Q?9AQYXVgJi7TDCzxx6Gs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09622560-15b3-4e3f-a3f3-08d9fbc39b6e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 20:39:39.7049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 050Te0T5UOovKxgATMIkP2/8LleAGdO3H/Kkd0XJV/UFWb/AtkyloAV8j/y8Mdt0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5516
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 12:30:47PM -0700, Alex Williamson wrote:
> Wouldn't it make more sense if initial-bytes started at QM_MATCH_SIZE
> and dirty-bytes was always sizeof(vf_data) - QM_MATCH_SIZE?  ie. QEMU
> would know that it has sizeof(vf_data) - QM_MATCH_SIZE remaining even
> while it's getting ENOMSG after reading QM_MATCH_SIZE bytes of data.

The purpose of this ioctl is to help userspace guess when moving on to
STOP_COPY is a good idea ie when the device has done almost all the
work it is going to be able to do in PRE_COPY. ENOMSG is a similar
indicator.

I expect all devices to have some additional STOP_COPY trailer_data in
addition to their PRE_COPY initial_data and dirty_data

There is a choice to make if we report the trailer_data during
PRE_COPY or not. As this is all estimates, it doesn't matter unless
the trailer_data is very big.

Having all devices trend toward a 0 dirty_bytes to say they are are
done all the pre-copy they can do makes sense from an API
perspective. If one device trends toward 10MB due to a big
trailer_data and one trends toward 0 bytes, how will qemu consistently
decide when best to trigger STOP_COPY? It makes the API less useful.

So, I would not include trailer_data in the dirty_bytes.

Estimating when to move on to STOP_COPY and trying to enforce a SLA on
STOP_COPY are different tasks and will probably end up with different
interfaces.

I still think the right way to approach the SLA is to inform the
driver what the permitted time and data size target is for STOP_COPY
and the driver can proceed or not based on its own internal
calculation.

> useful yet and you don't want to add dead kernel code, then let's
> define that this ioctl is only available in the PRE_COPY* states and
> returns -errno in the STOP_COPY state.

I'm OK with that, in acc it is done by checking migf->total_bytes >
QM_MATCH_SIZE during the read fop

> devices in STOP_COPY and let's also define if there's actually anything
> userspace can infer about remaining STOP_COPY data size while in
> PRE_COPY* via this ioctl.  For example, is dirty-bytes zero or the
> remaining data structure size?

If we keep it then I would say it doesn't matter, userspace has to sum
the two values to get the total remaining length estimate, it is just
a bit quirky.

Jason
