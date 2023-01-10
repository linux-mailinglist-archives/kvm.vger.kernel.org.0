Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7764D6643EF
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjAJPC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjAJPCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:02:22 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3539E1D0CC
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 07:02:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkvaB6/oAytM9vwQPBbAc4HFYX5Hs9Gh+lpsqoyMGuPOygiHKyriPOPvwgjidmK0c7ZFqaKnUGco0UxLLqGBj+cuLg+QECPEyua+eyZIyaeqKMYJwJfS7b+/trCS0GHMQFpw0ZhTVA6Ju/zsio9ctv/zb8eWpQYMvuG2qs3/vHTL9gGBlebxWtcDvpUsfABpmy+JbQPeLbmsPvE991d/07NpvcVbWigIivL+TC0TRqljS/5EdSnk7jkhHXNnTghDuBNE/mNH5K2QHAQLwI+AOerPVvr7E6hs67TRXSyGdjsPq2SJ7U4FdQ3/29epABTO/hZ3beyMKbd9EAEuZsNiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3vrXaq/xPRyNkbJ0E8cfCm778Z/RJ2tyjMy6YrLtw0=;
 b=cAVvoO/bSxQEv1kjYW+BXTESf75kBXkaSfMb37zclwHKP7Rm1p39TMs3RfKSmkCfqw45ZousmjRtT+uE9YPWWFpxy9JjNiXE1AWROBT1f4B5gGCn+DFPXQXbklgIAbRyzOnlKSHFgwQkkVW3sJ6qNKc8oNjuqWmQkCKvz5IBEE0zeGG/VyeU+9eP+V3y9hFIEmNcPVx02MnrxK+PgHBelwB5tDPsIYJ67Zts0mbMl71VNabqT3K/YhYFoX4q1dHAwYCkCGfEMr0KlyihC8ZqsUozp4hRwO4k9APcCF0sCcQP71Cs28AI22VZ4+KkegJqSlZVvbUzKzU/5My4jCU91A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3vrXaq/xPRyNkbJ0E8cfCm778Z/RJ2tyjMy6YrLtw0=;
 b=EuLblLOnmzBfXQgCsTiQXOXCEY9v2ANStW4D3oFV6P974B88gEm96Bbs650r2FiegU8+tWobbJHMaviqABIvlO2qAMlIB216qlqoOQYROMzPCkqu1bmd+ZSTmoj5IY5Uczfk1/OK6WlobOSv98g6sRJGkd2ShNW8zHEQAUY/h2i06pMtW4UyYGGBpsAyfnACRbdkl+qUEdDHZsD/ieSeiF0IYePqZH7+LQrCmY+BUfX929NaLjlLwxIcy8382I39HUyBsIn/+I4AflCybgJ3B72uJ4OHhjIU3F1hZ9YN5UlfRP4SBZ2O/llLobFoPfVg0XMmIZsDcmBAmBM54oO7oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6671.namprd12.prod.outlook.com (2603:10b6:806:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 15:02:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 15:02:20 +0000
Date:   Tue, 10 Jan 2023 11:02:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Message-ID: <Y719+4NlFxruAumb@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
 <Y7RHtRnHOcrBuxBi@nvidia.com>
 <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
 <Y7SAA6eJKK91F6rE@nvidia.com>
 <3ee416e7-f997-60b0-e35f-b610e974bb97@oracle.com>
 <Y7wcHg0d0ebC6h+3@nvidia.com>
 <25717799-7683-c39b-354c-0f6f6ff11635@oracle.com>
 <5d91cc83-58ef-3c8b-c3c0-421899bb0bcc@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d91cc83-58ef-3c8b-c3c0-421899bb0bcc@oracle.com>
X-ClientProxiedBy: BL1PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f5d3ef4-668a-4565-0808-08daf31bac40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NS0PJNg8BaxkDdaLfJYCTJqQ5hIq3f+8sZzCGq1Zglx2qAQ9oiawNXBfgboANCiRw7joLva/SFFHh9ydn18o/z8tb5fP9FNoZN2MwCAg2BcykBGCO0k5nbAucmddmn3CNjoi3KEWx0aaErFNFp/77PYf1b3ZBqPIJg5NO9V7Od+2IEbgZKR05POSqblQp+fDjVNgQ9d4Jr10K//x2798JGIoVEs7ohM/UWDTipTiBMEZ7jAOSbp2iTooHRDp6MbjGWqHRdVCvkpn7IzckKAXtHx+JbtDAp+JDEMrje5ZV+sKLAJ3pbw0Wroeiib4V3EEvk9pjNx9cOsUiePNcmDL2H5z3QDOgwWSQ8vvlhyfb2z5E9rs7e2Dy2yqvZYGSdsLafuFTNLmPTzKOikylag9wBGqMsuw0w5OM604orOEeZZpr0TqbFZvhVG7GaIp3Q1C2PMHUpUwBjeSIBuMWeQcMavh0UAUhGfhQkf2oNYxdvYA+UdIyXPdpnH/MqOrNoFLUhIaJZVqUjV3ZHMbiTQ5UFxtQi/oPZhuvKS/5yqraayoPs3yhxBMEbuIK3zJAH/kjKeARJ00TiQGW7KP3GYGXayAbRxPqJRUxdelmz4tBzG7Y/Diadk8W+MAao4LEzz2a8BtR36qhEYupMCQkpKG3Zxz1Idiw8a0GcqovMCd+FgjFvpH9vqz6upMhwQl2i3m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199015)(54906003)(6512007)(6506007)(186003)(2616005)(8676002)(86362001)(4326008)(66946007)(38100700002)(66476007)(5660300002)(66556008)(478600001)(36756003)(6916009)(2906002)(26005)(316002)(8936002)(41300700001)(83380400001)(6486002)(558084003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EjJz4+hEPn9iMfrqEcpealK1riO8Teb8VJDbpEFqcuO8j+2FLSJEp2rh3+oj?=
 =?us-ascii?Q?xKgSKY+uQNXk93fNO3OJXO20QRnAriK/VzyUENKFppAmNCnMU7Ad5cRKuoJK?=
 =?us-ascii?Q?r/yVz3UrOe075ATBc+k4gm459Lkv7hkaqR7CrrPitBlR/X4Goni5C1JBNg4A?=
 =?us-ascii?Q?nmftjXrsnUV0DlGo88V2+LrS/WFajhV6EvXa8PJGdwDaJU4GPNB1LUAcXPI1?=
 =?us-ascii?Q?JB5FslKJCf3YQc4Q7rFn0jsaeppM0l3AWFcSROVcOE2vFJwUx7Y/YGOj69V5?=
 =?us-ascii?Q?IGgzJrxH7TciAFoxYzpc1peu87xXddHsgw96tfe2Dxe0gpYLvltLF6yaWzKq?=
 =?us-ascii?Q?zA7bwFu1SHgewlK8IxRxnxLcYq9WBB7gLxFltjEMMzKunP22RpT0m3RZAMBY?=
 =?us-ascii?Q?dJRgrwP19eDi9eKVfuYkgESqUCd/wJ3ZLNi0k3sTokxs2sRbWQkk0bLjAnTY?=
 =?us-ascii?Q?+tjqjsL6K8sY7EYLa4slVCr2FF02j98m7UU7EFOBzdgr+GugHDKjiTW3cTIk?=
 =?us-ascii?Q?PxfHEnY+XZ0CFlDF8fqZnCCA7IhRnw3E+lIPjRcGKTxO9cryQSTs9fg+HlQa?=
 =?us-ascii?Q?gQezIMnHMsDEnmOfaYqmWGP0WdVnjs4RvR+GhVttgghvtxz4+zDi+ExI0Q8+?=
 =?us-ascii?Q?8uEtvA7mfNvITCVd1bpbkAhiCtR4wuzSWRbjPMDfgJFVpacBDEg62PxSvuNj?=
 =?us-ascii?Q?65vwz+6SN0+BKOvTaxJ6whmqauPWfJWYkBrNFid87eEj0BjbOFh0z3LcNygq?=
 =?us-ascii?Q?/fukpAZBeYiFEZ+svEeJzF5G3gjRzqf4q8kDdsRiQCW1vqoQg0LUzK3tePkn?=
 =?us-ascii?Q?bJHVZohjXtaVOj6yGj2MtzOHYT3AdSbQ0MN0wQdmrAlzsuE78P8Slo/xnRR0?=
 =?us-ascii?Q?ZEpBHHp4D42jOh9fQqerHW+qtotzYZzotqJXZxNMw3xx8AOy1HX1Nhgc9vbx?=
 =?us-ascii?Q?ypZChxYYH1HxxNlWZe9ISzcMLAMQUpVCtZ4M/oznEp9H5nAMKKpbGTNuLqIN?=
 =?us-ascii?Q?IdmzACn8M4E0/abUI0Cp5Zii575PdkOC33equecdKMGoMqPQkB6oRzZxcwMa?=
 =?us-ascii?Q?coKxC/C+iuwg7d78nhKUWF6Tp+0J4/YbJeS2Tqmi6JnuqnAkDBHxzl25ozGO?=
 =?us-ascii?Q?7p+Ja/yeW3UUXJ+Wnrh8f5/dtJv3XIlscnw7hWgRT6qhB5+e9lpLc6a2tZAE?=
 =?us-ascii?Q?oVls7p/n4TwMAUAIILpw+42iURMwav/LTIWHDkTJY57nNa2EFKgFQJ4oUSx6?=
 =?us-ascii?Q?PkkgZsjUVSbKSvuZmzlWytyAGJP5j5TAUvxp0mweShngxxE6WhEnE8Ediv4v?=
 =?us-ascii?Q?/9xKvAeSzi8hjs3GxAnvEb9U1FTl2pwy2OnMPhOn/cg+vslIXQ00Weh4IFXd?=
 =?us-ascii?Q?a1Srv/FWlYQSI5iju2w5Fji9LPpkIC1EMCH3kkNl+3Kl488fde7wlH6iOKmW?=
 =?us-ascii?Q?ZoRSQYNRHwtt+v+w9RHSSWQfJqS2jJWxf6PwWTFmTqs3T8M32X1HUuXig+mW?=
 =?us-ascii?Q?dBOGNnPCIfgxCmG4I70htADfbfw22BgXaRqEzYpmPkvZ0VlobBP7GOY6RKFK?=
 =?us-ascii?Q?k1zvWpjBCR3KbCOb5NA5x5d4nB0w60p4q0nt9ZmX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5d3ef4-668a-4565-0808-08daf31bac40
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 15:02:20.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +DIyplhAnovXLp/bop+N+10VaFCfaeSdFQefzdCGCW+P/7qkhltJaKUXzMc0r3mT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6671
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 04:16:18PM -0500, Steven Sistare wrote:

> Let's leave the async arg and vfio_lock_acct as is.  We are over-polishing a small
> style issue, in pre-existing code, in a soon-to-be dead-end code base.

fine

Jason
