Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3C4CBEC4
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiCCNUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 08:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiCCNU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:20:29 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F701728B9;
        Thu,  3 Mar 2022 05:19:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYvXIOSkcXJCqz7wqPOr88L+D11bjPYDhZpO5+NAyeP+UeZCeVbZudzBNer0swRchVBQBKMbTBr3Nm5Him6EyRJaYSZN7fxOtCKSSHG0ES81z+9CCAqai0/66PrlLLmdOFlJ7JwWUITgbSf33FrWHQmLoVtT66TwbwpHuWezYv4Jvacr0QMRfyhJoRyvDEqSsI7SFNEVmJaLSh+s5FCWBA7g95R+4D4nySD43OwrPm3zAKUq5pRnZ6QDKYVScNhRtCanHs9CV1tRGs1En8CCl9oZ5gpJL+gyFRfS60D5DkEWDpf/qb9cyxCBS/v+I7u9u8eOO6y6h8coOAqWFY7sSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhbvHDsUuszMo7oC8wIwTpdQbSz1p5ZVryOYfqU7BoA=;
 b=BWbjjFDPZNnDK1snpJiLiyRhdZ804GOYVVE975XRzzH3zygozrB9mIyH6y2Bwu1En8f6x0R/gKnuof7DbzozZfkG5TgPyETPzGCtLQugXTRj1GGOzoNOkqS4jw951+PB7LiyP94fgrIfgMIn5bCkiQhMrSTNnl9D1FuWUxnJNyQhyYafkZSfRsIiaYtmPrJjHbzreGocngSag+55yAFc93+cd2lPKuorl1bx/1bW6fDzP6qnfhCJhBhYcDyANoX+3W4YEIPyqiqy3dY4310pLEAgJ0SJa++0IiNz3w0B2AAAqKgAjwSP/CbTOxD70ObftzsiSVBkv/NNMYsZjxXC7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhbvHDsUuszMo7oC8wIwTpdQbSz1p5ZVryOYfqU7BoA=;
 b=nohfQiY/PS/2REJzVBaQtqvTFVeQA9D+BvfCRxm0XetmTn3ecSfos0730IEIzixsUlsHi2Yuxhgz9g+vNZrqqP7t6mgYAE3ibObqZIxXHZ7QgRECxq+jKspQ2GNZ9jYutKI9kxmv4iEQ3sE/Cx8IAbHcp7skQ/NSVWSWibUkGmNdajvJ0D8f//Mb/G56yWFXOPgfDm1qvzBdes0F9MuKi6FQFixBY4d210WBo+jq35OWz7e2IaPYDNJi6lt2NEA2KS9Um1ALty2Q670scF+t2eUW9b6qNS5wtWRTb8GLAUZAum/rphu/ywCLV6Wd7ofLsNRVGG6P7kvr7JFDYha01w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4300.namprd12.prod.outlook.com (2603:10b6:5:21a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 3 Mar
 2022 13:19:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 13:19:40 +0000
Date:   Thu, 3 Mar 2022 09:19:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220303131938.GA219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
 <20220303002142.GE1026713@nvidia.com>
 <19e294814f284755b207be3ba7054ec2@huawei.com>
 <20220303130411.GY219866@nvidia.com>
 <f2172fa9f84447699cb0973bec3ca0da@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2172fa9f84447699cb0973bec3ca0da@huawei.com>
X-ClientProxiedBy: SJ0PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7901968c-149b-452e-8730-08d9fd187926
X-MS-TrafficTypeDiagnostic: DM6PR12MB4300:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB43006AE882325377101D177FC2049@DM6PR12MB4300.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6VMB7RGqzKvSWg4Rj6HqmeNG8xMCUH2cogf4ltvafyIN+w2hWPudozfGYcRrtKGZAWgHEXcaX1mp9JNXvc3yfPJqwHK0dz0xbXu+1lQVkKzaf4UeCkcNJyo69Lyz3JEuJH3Y+DQFTW1INiaFSXr8DBmz19qlPlPKcIl7R2uI4kysBlLAa5d+MlOM+fvMpE5fI6LWUc1R/aJau6jl6poNGd4rynMMGZ4R7kkxZl/eCQDjIAgTKn30EeRzlvQULsmXHj//pXXnOSeLkNPOPwk1nCCvLaVDOYMfDODi8Xbmgc6UhR79/JFQErcLIyoUD02SVgZQEYAACUERxQtYT0GHqv0A/qlARDd1aoSyNlskz8qpkYkVxUIfdHU6ct+FzheJeGdktlJFUNbGQ04KRnoT1PRodTkE4/Y37lf2bSS2rUdSS6Er+24PuASgpoAav8A5MpeBD40FDzH1QDRzZ6haWwot7J9MnSn2pyshNTVgDtzeU3pDerjCg44Q1xU4PZ7uK/HLI5ZBoeciP8xJ8ayzxcKTYdX5aJitBWRtXhmmO/kZbdMGPJryUetSPkwuMrMT9SQd29n8pwK/t9LesnWFYF7kfg9mUq3lH43g2iLzpe5YyNF4PPNhxtUrF0v6sjRQcTJwwK4xLua8hsMjPilZ3FVEs8BBW0YbxiUrcgDt+Fc4zmbBTdzbQHwEnozNCSB9u4bQp2pW2ZELQ3f9eJsVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(316002)(508600001)(8676002)(66556008)(66476007)(66946007)(4326008)(86362001)(2906002)(38100700002)(54906003)(6916009)(33656002)(83380400001)(36756003)(5660300002)(6512007)(7416002)(8936002)(6506007)(26005)(186003)(1076003)(2616005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NhjQGQ1y0UolOJ7dBWMaAT0YBvgVW8xbcSsxogaNu4tF6r+8zMzEor9fCAJ1?=
 =?us-ascii?Q?zRrrxLE/Fwp03k9MG9Q25wg40v/AMuNGx53Vz8xMnyccimTCrM7FcxC55sHV?=
 =?us-ascii?Q?VgGABIf8iowFE7NoTIbckXNp5GJTB7e/58MbKZ9REbLsMQsnTWvwdTGkKRu9?=
 =?us-ascii?Q?PCZkMmuGvPAJb1hlKc42FoSSgd9gURtfzw2lRQESQwyT+Cxxhirt/KqE5199?=
 =?us-ascii?Q?VzZbAEkXl4kll68h+2eLqZ7+0qg69+dqjNaBG5GfBSGr4ggAd6XGIFBV9Xbc?=
 =?us-ascii?Q?qBPLDEjJ8hVkMqx2hC6K1FPQWLFr0rvccZUVPr+gy+RlUPYFHgs1p5oag48K?=
 =?us-ascii?Q?B8RwKV2L0Rd1DaU/Y7YM7+szjaJ3pyf34RoEYXG1iYg77dLN0YJSrydiKXFt?=
 =?us-ascii?Q?lpODHJgfh6fIwc0lkwIYrScC+/7gwJh7Oj30z4twS0r6nMFHNoPLyZmRs0Te?=
 =?us-ascii?Q?DmTipnKBe1ObBbEOU13AnbuNqbO97L1wMRxn6LjQPOv2QHM07qQJGd54NfZA?=
 =?us-ascii?Q?gsH2adeH2tvwufs/3BXFD7mBVbqLeHg9rS6Wb2brAkaiezN9UgRp38VjCYYh?=
 =?us-ascii?Q?LnrOwpYoCBs0xpS6AEFBg3J8fE1SDrfAzDIdz9NWn2jPMaXGRVKNGcL49mn7?=
 =?us-ascii?Q?5PvQaB45jbWSwSaWsX/UUzw2Oot/TS296r8SqWUANuOxIR/Benx1TqmFuTAm?=
 =?us-ascii?Q?yAx9y0uTDVmZhnO0so/DFxTO7yvdHWkkk1NsZQXWMD3i1B73q3bjcjb9pQeO?=
 =?us-ascii?Q?fmpjlT7TThs8MPnXDUCBUjc9CKiYXcAh+j3iObYNe4WAywkILtQbzr6zFuTA?=
 =?us-ascii?Q?tmgnBWEoxx+azmJq+zw1kfWMX0xVMbonbP9uKek23rdqn75NVnWCDfwIZPE2?=
 =?us-ascii?Q?agekTor6FILG3CX/ggYfiq/ixoa3B5PaVG3LfSHVCp12OKxo2v8y333Wuruo?=
 =?us-ascii?Q?zlWmQ+IDG7b0pMgt+yhge1DjhT7TwTx/Bp5aU3XJ2FGXizrT8pq3ZrJpIB95?=
 =?us-ascii?Q?4gfWfc2CQoEBShYVRQnmhAvbDsjuwdqgk7ofTVt90mjhrAiMyUEjPRDhcRlM?=
 =?us-ascii?Q?iU5afyOtDIWo34UmgxU45lDAvtb4sWozex5HRgLhbr6tZPEiR7NZYmRHO7Rf?=
 =?us-ascii?Q?TmGogJHpZSJ4Ua+mIYYvjE+Pw94y31xOXABjEb184HPek2Byu9e95EOgTYL0?=
 =?us-ascii?Q?LS629SHPD+FIMtM6ZWXWuNyQjaVAD2mE9JjGDqHpBuBKKJujmepgtFSBgRTu?=
 =?us-ascii?Q?xY/kltCS3Zv5RIusCysoMyViokPy0ZYtUrr0bpX9V6cqhWMBTw+gammI5aTL?=
 =?us-ascii?Q?rjxH6CW0uRwOmCxVxeE4FBUm2Mo+Am4aLfiVcmXNDma3S/8ohJ249wuNg1Zf?=
 =?us-ascii?Q?y3ArEsteL61bzUKt67f2YJdLOBBtyclmLnCdICG/ACbx0rsy7f4JvNCMS/mT?=
 =?us-ascii?Q?4suYxxfGH0c6Dfjp7TMl8SD+3L6tUOuJBXA+NytYOjhU11nOkbSzGbk705r0?=
 =?us-ascii?Q?kjC0hb7NCogg3bGq8C8mIxbyN68vcRVQmtTGJWQuNir7praPphlL892q/G8B?=
 =?us-ascii?Q?5Xg40yOKu6IXLWEolPk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7901968c-149b-452e-8730-08d9fd187926
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 13:19:40.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFQAUpdB35HC4Cf9QG4oO/SJb1Cp9ioBycmp2knFdi3vRyboFU0Rk4KRpn1qZLD9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4300
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 01:17:05PM +0000, Shameerali Kolothum Thodi wrote:
> > Tthere is a scenario that transfers only QM_MATCH_SIZE in stop_copy?
> > This doesn't seem like a good idea, I think you should transfer a
> > positive indication 'this device is not ready' instead of truncating
> > the stream. A truncated stream should not be a valid stream.
> > 
> > ie always transfer the whole struct.
> 
> We could add a 'qm_state' and return the whole struct. But the rest
> of the struct is basically invalid if qm_state = QM_NOT_REDAY.

This seems like the right thing to do to me

> > > Looks like setting the total_length = 0 in STOP_COPY is a better
> > > solution(If there are no other issues with that) as it will avoid
> > > grabbing the state_mutex as you mentioned above.
> > 
> > That seems really weird, I wouldn't recommend doing that..
> 
> Does that mean we don't support a zero data transfer in STOP_COPY?

total_length should not go backwards

> The concern is if we always transfer the whole struct, we end up reading
> and writing the whole thing even if most of the data is invalid.

Well, you can't know if the device is not ready or not until the
reaching STOP_COPY, so you have to transfer something to avoid
truncating the data stream. The state here is tiny, is the extra
transfer a real worry?

Jason
