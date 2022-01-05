Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4153E4852FB
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 13:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiAEMpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 07:45:39 -0500
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:2784
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234151AbiAEMpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 07:45:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnFDLgdyUBoH4zzHhvrMYw4JLAg23G0wuFpDGm+tXe14WYxhi+eLbjzP5LjfCH2Wc9uk+v/8KSPvqLzcNS2i6wPqkXe7UQN9J/9DJfJ2P1cl+/Eu+P1oix/Oc+W/V8303llv2hZ3kHDCz/INAQzYIVJqQ4SuqSRWgQAyj2kuobDg91khS9bfq4dEY96qHdR5Ur9fkgWqx1wtxBa/Xwj71jJzBEv+hq2sBljNaqSIA3PctwJr+3aIk8mHOLUxh8PjdWp7kswNysDd7gKpS4NuL8khAL8Zej97M/tRgLQeuWMps27KTXl5GfEwh6mQ1B+mCA3ZYlurq6jeDPc6rJZhpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPpAl4ejzHKITzzG0TaohHAc14M9Y8OGpA1NKrlyCK8=;
 b=OjouxRYoAOQULEYuIOy3blcX1Y2RUD4cvnDt9bU7QE0XEVF4IibWUJuyiU74VDrla5wqOPwhte4cK76AqQiXE+jPE4oetkV65vO3G7wYn/r4/YXKJAmxmLnYRBUJnxws43DY7xrA6qj1lcmQGl+PFxMrnpdNok7DkTebkPwE15FQ6L/3arWPF84jumUOF3YK4ILPg2kzyKQx1gBWHLlYP/ugcjjkXL87jM638eoV2HtlsDKmKMQz8HHXWHFymp91M0HT2sy58M53+HV64Np52KXKSBdv5O+dDSefpw68vl+xan1ZtrHOh9d3BgCR4wrkQT0wrTWhsB8duT8K50bzMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPpAl4ejzHKITzzG0TaohHAc14M9Y8OGpA1NKrlyCK8=;
 b=VvuYTebUDoHbr9HUBxekuuZXvrbpcnzKjox74MxNb5vw3HxzGq+HTQjnyCBkvI1/VD38sTNut8KHYpPN1vwMj+FgnPIZC7NEn9l2bmhiIeeoSISwQK6H/raWxD3V3jIk5SGWrQ6ByI6a2/7RMBFcuPyHRpRINtL8UoLW/iFMmLELL3y2YPIvakr1wQYq7caRsppA5CuZuDCwjOCeZ5EFG1i0DVlhba1xq06+R2pRyoZtRMExv/br7TXDFk6YRDjiu0HcljSsA7R1skMgvSxTyxsM5Ke+7aM5uTksPGRdcOoQDgmJ0mymxE7sHMAeKQc35V3jhtvJl+GDUsSOP59UoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 12:45:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 12:45:36 +0000
Date:   Wed, 5 Jan 2022 08:45:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220105124533.GP2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:a03:54::45) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c228c76-cc63-4de8-37c3-08d9d0494538
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB525694531A272D642A375A58C24B9@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EsaX384nIRNEHyLt8qXIPtq8EpDe9gm/6YxQ7ki6bHUkOMHCeLwR4jB1PPJ2e3+kRcnSzNKASm76mPRskUD4nJ6cRmJrGzhjInrfys0erBV+bGkYGPeBDtErGOlYgZy2kSG12Z+pITLgaZmJ1u7+dfbT+FXPyjnHcnl6t9iT5ZGDoMS8fnZ6fIaoIwA9B6hKTIUIcOv5wjNubpMd4KPxWDZZnv5wdXR9RhHs0N6y0qfYWBiZiZJ6JnT3iUW9E2leyYcyEA5mAkU/RJcYoWO8XeB/gXg5ENfJ6+Jz1MXEDrjOkRgC5LcDPfuExBXb32WWdPIcmXTrF7wXtCeJ1vDH/Qyi48sy1hVGiBJjVBbVRjxlPNVM12702T7LwZWpGm0i/WdrIJ5bdKDrWz4CwX3JSBMAGd0rzFblnxV36ZRB0zUSErImb3/cw8zQDUp623/QRz4u8vLg8jTdOQZ/R+BNftexlXLZIa283/Q0tvDhVGzRxmDX/eugX7m5smUSgofMj3LMJ7lwIR7PcOHs4Hkzd956E43TMMZzS1Kh9GdDw5SMudbexRv9fNPBYXbeJp0RC/GN+ZBnY/NcnVjBYZiL+G39hLf605Gz4IBwfBPVNgjpF2Z5uGvP+Z+cbdLOr/oT//+BrZJ6BLvMay1qiqjJWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(6666004)(316002)(8676002)(6512007)(6916009)(6486002)(6506007)(186003)(508600001)(7416002)(86362001)(2616005)(5660300002)(36756003)(26005)(1076003)(66946007)(8936002)(66476007)(66556008)(4326008)(33656002)(54906003)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xvyEAJPc7V9JNEqAWv3hg8OtDTR950C+63dnX1XjQTYkK7p2BV773HiseB1j?=
 =?us-ascii?Q?sbnZth5cuRhXHHE7b8Vu3vW7WQ71It40b9HUWZ5eVxAh8FcVWJGnxDsKPDaL?=
 =?us-ascii?Q?jkOqQiWRjHNETU5MPb91vV7bn9/h5SuK90245gyMb3WisitIaoQonsy9XWl+?=
 =?us-ascii?Q?9R+MzXoQw9lYMPtesmkmVevXPO9jN8H23bINhyWobSxEPz5Roi9fU5SNJYhQ?=
 =?us-ascii?Q?RKdIa3QgEJQdIou5bvxEqXp70ot6A6ldfTHCSUG739lXsho/Gfeqd9dsch7V?=
 =?us-ascii?Q?WHFcUf1+vqaytyJpG8ZE8ifU57TVm2IAW/NqGJMnV8xfk5IQzM8tGrCMTH89?=
 =?us-ascii?Q?EK5mBk7s00JFyX7y+1+JuIz5HWb68H9S6Af5Yozh2d2H6EunPDeoDrV8ZvWs?=
 =?us-ascii?Q?QkBgFA9k0GKWJodH7zRAvUKbn/wVVq8gAgnzeEjFdHu8CNgwRNpu7LuMqfR+?=
 =?us-ascii?Q?chkTtIqPQO0J1or+iASCUMXHncrtTyjKrf2gFbaroML7DT7TzqonzyFNEZ6J?=
 =?us-ascii?Q?bowr4uPu/si+uc4QKtF61knoAkMuc3qb9n9lJXpjnV+zkx0ajVTWyhirPUtA?=
 =?us-ascii?Q?7/+xLlg6+VvoMVhXFKIgKoiyzjFUQwyk4mMZOaF0p7mXz1R5rfAp2wVTUP1j?=
 =?us-ascii?Q?YE8TgeJSbobJ9H7MaxGMx2O2+X1HJ/F0dfSr49jHDy3+vYdZsd/RNSI+Guxs?=
 =?us-ascii?Q?xj8Nevgj5avn2TEEBY+tqglaknIGaX2/qtA28PoSgJTmMrr1CPJOrd5hXkDx?=
 =?us-ascii?Q?z6Lf1uN1Z2Jgvmfwvg0E4RbxVrl77s7wQDCB+XnL0cdn1VYtVorjffLmc5F7?=
 =?us-ascii?Q?VXgrMJf75lzJ8KPMy7PxpCeBhvLDUw1xa3EHxWAMufVqJlH7Dr4GHSBFpljo?=
 =?us-ascii?Q?DYnfcxbHa3WndTN2CqgRgUONtwR8vRd084ZKeQ0mtY31xDvxKosZeitl0Dfp?=
 =?us-ascii?Q?o/muj3M553bjxL/DRWA+uwqXzH8G28AlufafhKQRuw3v2DTAXJJRlMvGIk+0?=
 =?us-ascii?Q?5aJ5/k4myuHihYAeuYjwcEvAIv/TjPditkIwyxBosF6a7IneCzq2B9TL9HUk?=
 =?us-ascii?Q?kRM5i6tfEuM7ZJMd5sGKCP3nV4tEcMYSGRsYDuouZ13tOWN+bbBT8Mjxlccj?=
 =?us-ascii?Q?YW2zB6AA0IFJbusZouCoejjmpVRg7mc75YMqcefaziKtR3uSXntjH0Jy5QrN?=
 =?us-ascii?Q?pEdgbum4iQGG5PWYUi1+cFUwI+qtmbVTpLS+8nvZPaXuLRe0NNB3qfK2XI2T?=
 =?us-ascii?Q?CDdUVueCljzYMiBq+ZT2dVcfcHwQfrHTiP8ujYqmm8cxIs08FrKAOyv8NMnv?=
 =?us-ascii?Q?0x93mtD+/UpOIAcAMB+XpSSOt1XkVws7OdqTAbYQXbT3oZA0GhmizHwJXscO?=
 =?us-ascii?Q?AfWho3VcJixJwuFPGgU/wV110B9JGqB/2lBDfyu26IywxKYqsbgvVd4lPmFv?=
 =?us-ascii?Q?8D7Pg2ZySeZKZSqIz6kFhQpBnIJqfeqN4dssd/EutKCdErxRBb2ed06mwyp9?=
 =?us-ascii?Q?+1J80VmSwNuUU80AVdBSavzNAGz4OmK9pXzO3cNFLkEOlTDcWb/PDUNAcxEB?=
 =?us-ascii?Q?JYgsmQSBfWoyB9pdfXA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c228c76-cc63-4de8-37c3-08d9d0494538
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 12:45:36.5574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5u5Ga69zsuIIdxetEdrff10/F/03NUzT9AgCqJ6tHPuaBcjSAH+67n+Ekcizofi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 01:59:31AM +0000, Tian, Kevin wrote:

> > This will block the hypervisor from ever migrating the VM in a very
> > poor way - it will just hang in the middle of a migration request.
> 
> it's poor but 'hang' won't happen. PCI spec defines completion timeout
> for ATS translation request. If timeout the device will abort the in-fly
> request and report error back to software. 

The PRI time outs have to be long enough to handle swap back from
disk, so 'hang' will be a fair amount of time..
 
> > Regardless of the complaints of the IP designers, this is a very poor
> > direction.
> > 
> > Progress in the hypervisor should never be contingent on a guest VM.
> > 
> 
> Whether the said DOS is a real concern and how severe it is are usage 
> specific things. Why would we want to hardcode such restriction on
> an uAPI? Just give the choice to the admin (as long as this restriction is
> clearly communicated to userspace clearly)...

IMHO it is not just DOS, PRI can become dependent on IO which requires
DMA to complete.

You could quickly get yourself into a deadlock situation where the
hypervisor has disabled DMA activities of other devices and the vPRI
simply cannot be completed.

I just don't see how this scheme is generally workable without a lot
of limitations.

While I do agree we should support the HW that exists, we should
recognize this is not a long term workable design and treat it as
such.

Jason
