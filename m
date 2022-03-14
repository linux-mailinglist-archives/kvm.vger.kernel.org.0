Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7294D903A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 00:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbiCNXTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 19:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343648AbiCNXTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 19:19:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63BA1EC60;
        Mon, 14 Mar 2022 16:18:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsSnjgyR9So/uo3RXoaj7LYImPMS6l+OKFP6zjr3iKJfjNbJliI5hwbHPocT18ZKvnyNUDY9miKCVz6gauRhU/CCqR9e/fFnXaaqhkzTHLXxesMkxVS4wUOYyXAfp1p0Hxk5VxFYBCw8/vabi0v4kGk8ob23/0qwQFEhpdn4tIDheL/dTAwZ5L/7SBuLyO9l23WCtsjrPljHsXxkahxiRceaZOLl97XlPnlEAW3WnUkW0iWz0fdU79aZQ55Yc1ZQN74qF+4GbvVDUB7jcUHNQmxxDI9kSfcnNRzfMdCRgET/nWo1YV+YA+y5n3X24ooG7oDs6L0mDVHYUltRPDw6LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGF12aH3/v0ifRplwsWDlRqU90oP4nms6NX05QFu/Xo=;
 b=kkBNRsuXpf+FfnnAFL4KFSKq9BR6GoAk+Y1QKCQKxIEJ0C3QYl4PaFDoJ+gB+tUvQ4D9K30EAYsQYH+5XVSzx3kB4Xo1HetPJuFKujCNcpBE8U/8vYeftfL+6c0m1XkfnhfGzE91+4ykgauZlS8N5ESgNCkMP0oog7Ue4g4hsRBpDKTx3zrpxLe5FOGCHcnerCDV2npD4LUUqO6ArMcSdKAEmAhJ+BDinA+OYWUbBG2iRbD9x8+e074K+nk/rflENF8Y838okLs//8sULojGCxKCbTIoFQFoGQf4CWMOXS+l95KJOxneW/4Vnv/rbqYJ7t0rfXvFuR/3b5HtJKpEHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGF12aH3/v0ifRplwsWDlRqU90oP4nms6NX05QFu/Xo=;
 b=MKRAOlEQY1O3/y7dt8/eFud+0rwKNiSskTcs5tudLXpX2u7zxVUQ4Uq5i6JmYpXeZVVlfb7GwL9LcVSy4IaYkY3uETjEzSVDBVx1D1W72S8j/zuPkKGUNu6Iv1yKG8ydD5RSu5zj8s804T+UOaWwRxs3Kwc8pIEsw/0nfDcztDEuHhpXicrls1SZLhXPvpbWjEPcYJdZX2hyYBQ+5DOCvtwRIOWOOHEtFMD271pJCupiDyzquHgrNU9BL518jgKPGUIdBzGFc92VVguzBMHzbKYoXiXtGyGhdgbasxcGTolPazR2N0+XHHj3iIijcSJIF2XZUO63YWAFTS0ZnKABrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3807.namprd12.prod.outlook.com (2603:10b6:208:16c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 23:18:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 23:18:02 +0000
Date:   Mon, 14 Mar 2022 20:18:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Message-ID: <20220314231801.GN11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314165033.6d2291a5.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0271.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12b27398-b5f5-4673-68f2-08da0610e322
X-MS-TrafficTypeDiagnostic: MN2PR12MB3807:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB380761E41F8BF5BC4BC43DE6C20F9@MN2PR12MB3807.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n00TBbp1uFo2INUhN1H8J6OtJFzlnbmJ5oD5nIBsJgCN/DPfQKpGrfvGSDsHuYJNv4Fe0+RMJv2lZkTFAcdL4o+u68nSdRvke5O9e1OYH4tv4Z/mQRlNNNEAYFr3SBuLCqZxYkIuSmKewa+UQk1cVRUVWVaImKa1sNF7YfIATp0VQG1Czc5KCR+Oftpu9dR5h2ucUcA+ymkfSW9+qR0xTvRHTvQTldiKgWk72CJ7WnDGTia99HVzYSPHAsP2/S3HKfwBq3z8BmCDaYQOGvhxCLDb7X4jCcJDOMD9XOooPFe0/LdqkEMbM7kpU4vWtTDyfNiDy7vb9fsR7xL2JDLPRRf4oDJPJ/D9EitR+GthEHrQOU0oKb5DpxqkXmT5hb6yxM8wmb8G9ppYdDse6RKEj56todnsvwMlr1GJpT+W7bCMReWOlfWQ+7gjySXWllzBb9vCB4FE5O3koZKIiNdsG5k5jZW9EKWwwwxQJMqWqM/f7NQWaRwE4r0UxfKAZVOUMhV/wZ92Zq/zMahDqfwfhl1vlvWAr97r2x3K/zErvMrSY3KWCGhecQCdWKQxPtUNAa1z4Ulbb7XMpgcbtiKVC1DS6Xeq0BUuPRko4GxZJfbdf2KQcZmec2A6ws/2qpZoTLCMd2J640Mpkk8wvgzKuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(2906002)(86362001)(6512007)(2616005)(6486002)(6506007)(1076003)(38100700002)(508600001)(36756003)(7416002)(4326008)(5660300002)(8676002)(66946007)(66556008)(66476007)(8936002)(33656002)(6916009)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/IXPgaZfkQkE6yLgTeClTstorqxyfqAjXrCBmITb14sOnAM+ePo2/eHfUnOr?=
 =?us-ascii?Q?plSdwJWi5XACeogqBk46e6iLS6h4y/abxMMv2PYM98jwrrIi87H//Bt0eHe6?=
 =?us-ascii?Q?2LdTC6u5Gkqk8N+vFijIiF2z/MKWaZ6k8Vsw4McygV7WcEhxoU5I+69n1bFs?=
 =?us-ascii?Q?pggPRQFMzLHDHN3/UTDKA0ePSeg2I4GdUZZoIC/s3UnH8k2A+kCXAW4aib8/?=
 =?us-ascii?Q?Gcswc3XhCrtgYte2vMu42LuYOmgylwQyIYwF89w5Li1j9p0xffS/diRG2IVS?=
 =?us-ascii?Q?0BfnUlnps4Cptpw4Xb1gcW9K4bUP9fJVEjuG1Y2yv/D1IlAicWlVyS/bewMn?=
 =?us-ascii?Q?6vtau6Zm80KVPqR1gKBfE8fx1jHi0xKdbF0BWnAIOf2kLVKF77KhgqT+IKEb?=
 =?us-ascii?Q?/LavyB1qMpI8OvLvJWz21+OJ94E/3yOQzAfMYGf3I2YGqIiPvKLuWSWNYA5+?=
 =?us-ascii?Q?vNvu5JBa3nbwUt4cCQA7ZHS+HDXx6gteT+Bea3J2VbpKueXOLy5DdqMHVc/F?=
 =?us-ascii?Q?8k8Gfz5E4TOeVZTfEsyKU6oD0TZmrI6xQcAqmrTAOMblVV5Vz5WeBofMq1V0?=
 =?us-ascii?Q?DVNolAImpwxD4ALJDBBVj+m083ssBnqNXtZiF4JcniF29t+peph3f0+srQrW?=
 =?us-ascii?Q?nry5HfbVhoaMdNLIL3Rt3EGC857WW0xtH9Ej6DsKu5XaRsiqyHibf9+OIDWZ?=
 =?us-ascii?Q?XZcfaEIGALdawRySYsA9yD8QYvADiN9pX2IyqUK/R+fuSuppeweoCD0c1GnF?=
 =?us-ascii?Q?xFqyNouMFtxTg1pQW7BwsiqRZkP2do+wgw0BJwhIX53XO9j+I4LnAJIOXDxu?=
 =?us-ascii?Q?k3tbxv8Db5qHefsIoHhTxR6Prm12/lk7Sq/BGdC66vKaPAyPBkJYl+0MrZdf?=
 =?us-ascii?Q?lFgK534G5HP3ZkNfWXqTtZXrEeaJlnA/UufaF2oit2oao4FulqtTHG3lYtY0?=
 =?us-ascii?Q?oq8yvylhbMKMTyGGeLF9mhZfSfbIc0WINgSeWGImwAImKqVHrCJdKiIG5CWQ?=
 =?us-ascii?Q?QbAwef+lSRI5xaMSJi9t23wvn3Smd6r/+3l0IqNQ9Md28l1TrRAZGNo5ehcI?=
 =?us-ascii?Q?F+BlsYAC8xUdsuY6MCplz6OOTSjRfaLvtYQ/Qt5iuYXHWnRouE1hFukP6HIe?=
 =?us-ascii?Q?byOuHBUg4/z/Y74ZrKXYEygpLfZd4LpJtrFbd4C9bCCSuTw63rUyL6Ms8o2q?=
 =?us-ascii?Q?V6XmRZVCbv8o9YJ993An62L9v+3pB0d4LyJI2duPse6l1o2F4aUlPl+fTL6c?=
 =?us-ascii?Q?0US8qY1OP2/G9AlzzmzZ8gkmxu2KidkYNbiQ1iJruNd1YvsYu+CdciDxG6I4?=
 =?us-ascii?Q?TFQGd/EohYuGRkM3q29dO4BEEz8MOOuEpabXA4qel3k5CtGcdTm9g+hrtun7?=
 =?us-ascii?Q?3pEtzJGaasQFAaVXq7r0ohHfTkJcKZj1kQzgrni0q+5ukZGkYnbNpH2i+GpT?=
 =?us-ascii?Q?Exg/jGfriRs2phYgxpCp+CFl+eFd4JfA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b27398-b5f5-4673-68f2-08da0610e322
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 23:18:02.7678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hmNBa5TtT1m+ANhat5vaDCegxW9mKRqGhtcsbGA+33O/Q/+37nmL4qDHk9LtLZw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3807
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 04:50:33PM -0600, Alex Williamson wrote:

> > +/*
> > + * The KVM_IOMMU type implies that the hypervisor will control the mappings
> > + * rather than userspace
> > + */
> > +#define VFIO_KVM_IOMMU			11
> 
> Then why is this hosted in the type1 code that exposes a wide variety
> of userspace interfaces?  Thanks,

It is really badly named, this is the root level of a 2 stage nested
IO page table, and this approach needed a special flag to distinguish
the setup from the normal iommu_domain.

If we do try to stick this into VFIO it should probably use the
VFIO_TYPE1_NESTING_IOMMU instead - however, we would like to delete
that flag entirely as it was never fully implemented, was never used,
and isn't part of what we are proposing for IOMMU nesting on ARM
anyhow. (So far I've found nobody to explain what the plan here was..)

This is why I said the second level should be an explicit iommu_domain
all on its own that is explicitly coupled to the KVM to read the page
tables, if necessary.

But I'm not sure that reading the userspace io page tables with KVM is
even the best thing to do - the iommu driver already has the pinned
memory, it would be faster and more modular to traverse the io page
tables through the pfns in the root iommu_domain than by having KVM do
the translations. Lets see what Matthew says..

Jason
