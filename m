Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D947CCA7C
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbjJQSRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjJQSRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:17:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A2795;
        Tue, 17 Oct 2023 11:17:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vgy+Dc39CvxQU/ygytcuCb9EvAF8wUTn2L6TSoIM1R+jtjrCOFqHdu3rfHWMv4QXO3e99ma5dIc0Ev7+BpJWudR1UpPtqpFLjRI+bSuyKvWozmgjkXhbnkSQ5WEC7XiTEuJGZll4trCDjtFrW/A4wcp29YfTViCjzGg6DLRN2/BVohPa+/R2hvnSClCINXF80rOyMwf1ol8FVZPj9GcEzdT5/LiAkdtzDpDDGZa6OKtUnyp8XtZ+5PAIOhWbiZLsLZkrilNMy5d5qutm1zowT71EUOg97xcZkG2+nAs58jEST2gZgXVm0TGfFHqzRQrbKXzCZrBZ0VZ1kodUyyaWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btCVS1vlZmXylEeaZpgaZI+vaMSFkDU/I6PvJ/cV43M=;
 b=kKWVu6Xkctv5uo3FCOBXRQGMCYEId72kldpZ8Oxkzya4VrAuKkvvK4jOM/Aco/FRzOKSaUY3B7Z6kklIMf0HjJ+RmfIlQWO8H3jwz23ly7R4l0Sw5mFpG8m6Oyp1dlSop2cqUMW6H3tcdg+05VnVnqtgFcpV+ftJmSOj4oF8AQg/K2J6H5R6BUkKfPt3Gj0sD0nbv4TXh4Mjvgxx4m+ZJl9TLfRgRe+aLQV6XeUbchXKWEvxi8vJAVWc3MIasOBQX01/7iyiTrguWuB3Z0pFhBy9jD6H0jmJzikt3oj8i28CgPJBSaYSiwDtV6/3kjSpTPT55VWoDsyp7i5psWlVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btCVS1vlZmXylEeaZpgaZI+vaMSFkDU/I6PvJ/cV43M=;
 b=EF9rRJSicZoDK7Damun4CZ54KDTWlHMK0yfQKVAs+nyF2ddTXvApdd5LAbxWS5Wlw1R+dmgJy8MURtcvJd3VosAWdAH8m0I5IkoRjhqP/HxkOJOyT0Z8xOlsOTBH7/dl23ps9RXMgSsjmhELLTGeDas6qheIKn+uctu5bugQljk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DM4PR12MB5987.namprd12.prod.outlook.com (2603:10b6:8:6a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Tue, 17 Oct
 2023 18:17:36 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::5ff2:93e0:26f:74dd]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::5ff2:93e0:26f:74dd%4]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 18:17:36 +0000
Date:   Tue, 17 Oct 2023 13:17:29 -0500
From:   John Allen <john.allen@amd.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
Message-ID: <ZS7PubpX4k/LXGNq@johallen-workstation>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-4-john.allen@amd.com>
 <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com>
X-ClientProxiedBy: BN0PR04CA0151.namprd04.prod.outlook.com
 (2603:10b6:408:eb::6) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DM4PR12MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 019cc9de-665b-4c1a-0cad-08dbcf3d56d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lDSAA1XfM4ef/m8zCKToF2fgBbE5a1ypJuOGrZ+alFgu9E+jI5WUENXWqb9gC6Y5YiCUZkrx7GGcBfZsX5fsmcnqvHCrCSdD8yGBF4k6FQECjDhH/qaweznrIMDPF9Ahbzy31g/JPL2MOxvwW1jDIcZ8bPf5rk65oAEW0DPFMOY19SJ78Qvn4zDdbT31Zv907YCuDnlqFHrupzEajZ+3nY7V1qauB8eUPutRR1iY0/bvFMBL/oafwxlR/99Y/hB2zBP77OYwMjg4Lsc7lMKcHEF4FKML5zVn3Q3g7WwfIj6jnsSSkoFfykQobsCXDXD+tkR1VeYN0hJL0hWD3moB8miyGpmiDGXR6Me3M8+q8EBSF93UxiDqlBt9INCYQVLP17ySPXKF0/AoBn72yag/6GSvqPJc4CzsmJjk3KTNqYdd8VcK6EIYXmvm1yAW1HOh0vUnuKnVtbnYflEoVqkrRMLM4B4hRBp8S5KqDzMe8hfOOi6j1RLGcV8+zkvdmDMwDYjn4zw8tUp2fg74kLFWLNuWD8LXOjQaxesza8KdEqIYbfT1rxV4ALpUFBIe7tNV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(39860400002)(346002)(366004)(136003)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(4326008)(6862004)(8676002)(8936002)(38100700002)(41300700001)(44832011)(5660300002)(86362001)(2906002)(9686003)(6506007)(53546011)(6512007)(478600001)(6486002)(6666004)(33716001)(83380400001)(26005)(66556008)(66476007)(6636002)(316002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6XUWiT8jRU4cFjUrdzzBYZXKaBQ+zYsQVWvAol1oAen18oEkXImu9LijsTKQ?=
 =?us-ascii?Q?LtFo7BqxfQPJWioR2k3VgmwDr0ilWT4ysVZpAak/q76IFWphCk0AY2xyiZJ8?=
 =?us-ascii?Q?zhEIWpoTGz3XOHVX2syH4giVcARjxR2IVDU9JL4CEGHBq98BdXB1yNK3CSXW?=
 =?us-ascii?Q?VSBSdDK8HB5qJHY7ksVvFJJDLTI9MF18vaXwfJNpe+AfJLTsEGNGcacTUD+x?=
 =?us-ascii?Q?UpzdtsPvLf+nyJlgkuGLd5s6Wsp0RBc4BpPia9O+g2IyR7zCtOJx45c4ZhHf?=
 =?us-ascii?Q?RIw5/xTOcSWUUR5NB+4P2HUthzA3eC2H4wF/S6Y9QI5Iuz04X1gxNHWy7/i6?=
 =?us-ascii?Q?vHZBMEnAgzmF+Ij893pF3hGLhtc7xm3NmgkcyFJZCDCx+Q8T4OYReive2CAU?=
 =?us-ascii?Q?VfCnFEMJPYvCKK9fVkRO6meZUu/p77gA47fzVm34UH+S0AzML1szQapXErzd?=
 =?us-ascii?Q?GkmeAmk2AaygOjboprFaxkg45xxDDThaD9PZXdr3mnNLhG/aoWtrFEwlI8ri?=
 =?us-ascii?Q?zcfd/yglMUKHOxqVw2fEpaqpKEVOruJqEJoWGP896d9/MbfeDJfSn0zJ+Whn?=
 =?us-ascii?Q?2zR4GreuVO6NeRNbCBorzPR9cPGhSwsJJJODsnhHT3lSUkokjAMHxyTlSi++?=
 =?us-ascii?Q?tbZUCwsy4dRih4P4WoaeQZ5olm3HSQ1PuXqn2VWX0/d8b36hOXo9l9gUisJE?=
 =?us-ascii?Q?LKDbuhwn5zq3qa6O7J5Pu48nEyLFZYpYleAQBfbJC/nl2G7NAmvRkrsfVQ/b?=
 =?us-ascii?Q?IM1sQHgTDp7o1POH+u24ACOWOQ19pqXpm7rS/VJvWvm2leqMRPU+BAb15d2l?=
 =?us-ascii?Q?moQiCwV0nDsKE3Pnmnq+rdymiO87vb5pMf80L/ypIZbcv7W2G5UEm9yWA6yM?=
 =?us-ascii?Q?YBWWVPhaQkOPMHm7vpe5VUo3w+gwuRN7ZEns/lHiOs1Bc2cLAmcpKTmJwLBS?=
 =?us-ascii?Q?+1uekt86796104G+Bh8Qfjt8IwhIazayQTd2QV8MbTJAmKZbpoDoYw/4ofes?=
 =?us-ascii?Q?7VeSv3ZnE6Uixty6SrOHPIphtg1IQau9oF8tC6d8ZLMK3L5bQ+MZX5xOpW8W?=
 =?us-ascii?Q?NONEd8YH2zTQeiJx+RyI8qSsrQsXdr+d6AzMzOtaspp39Eue+f44L+mpgmHE?=
 =?us-ascii?Q?g4eRj0GahQFQZ9Va/Yj+shXK+cziY0akjWcLJY1dYj20LF6GfumqNdf4XaJb?=
 =?us-ascii?Q?3etEaKJfj+cJQvAb4Jnr4MbwPpbkYetiTz5zwVMRRv1EAwx3tQmsQpYPwSSC?=
 =?us-ascii?Q?FIuliVrPCOw5szhy+W1bEmgK+fjcQe2CfRLdHmYyCrOyjO4RLk2rN4HJPfHD?=
 =?us-ascii?Q?a6kjKybQnZWezrGSJQ/mLsu9EqFXBPBFgITsQCutGVr2nINfPYSDRdWCM+7o?=
 =?us-ascii?Q?pC3BivKa1XAWKSik1lMh0XgXzMknNNYOBI8obh8qkyL52PAn7D1hHD0/E9dI?=
 =?us-ascii?Q?qFMo4d4Bpsvdat5Az3oJAaTGswfVwBw+OQ4+/tRU4HyYEsMa5+SmEWxo7Lgi?=
 =?us-ascii?Q?DxtgGmKNBGWaPvNym55Vy52KgQiz09mUXJOLoEvqXO/uXoz4n6g9g1SpUIvM?=
 =?us-ascii?Q?Hnxn71bHVymlKw0JgV4LNgd7jpOkw2oTzephGQDM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019cc9de-665b-4c1a-0cad-08dbcf3d56d9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 18:17:36.1972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OEyi6/i6O+LRXAX+dp+WtPanpI/24pdLlIabsMjVhWR7WN2urXlBuAUsgqEU76LnxhLpkjPL0DFj9IIPKi2hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5987
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 02:31:19PM +0530, Nikunj A. Dadhania wrote:
> On 10/11/2023 1:32 AM, John Allen wrote:
> > If kvm supports shadow stack, pass through shadow stack MSRs to improve
> > guest performance.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.h |  2 +-
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index e435e4fbadda..984e89d7a734 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -139,6 +139,13 @@ static const struct svm_direct_access_msrs {
> >  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
> >  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
> >  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> > +	{ .index = MSR_IA32_U_CET,                      .always = false },
> > +	{ .index = MSR_IA32_S_CET,                      .always = false },
> > +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
> > +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> 
> First three MSRs are emulated in the patch 1, any specific reason for skipping MSR_IA32_PL[0-3]_SSP ?

I'm not sure what you mean. The PLx_SSP MSRS should be getting passed
through here unless I'm misunderstanding something.

Thanks,
John
