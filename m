Return-Path: <kvm+bounces-57778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 327F9B5A0D5
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD22A326372
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67FC276022;
	Tue, 16 Sep 2025 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YoG/yN1R"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFFF2877F7;
	Tue, 16 Sep 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758048935; cv=fail; b=Ae05O1YWHhrP8EygllaVav3tUdKqO0jSq5pK4Go0e5Ta4zbNfNJqIcZNeZ8EM0kbLONY3f9Y2kD3NeKQEN3GqtkcxUO8O5Ck2PLs0VAlQps9b4IoJ/cWMIXSBlOQyE7I+0lWbWL69JV5o9VPY1+2wbLHNeomcFcyBCoPPF7WzhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758048935; c=relaxed/simple;
	bh=4Mpspp/vRFYd3marJwV8VjN2iap5wjaJiPLvOGKzQnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ayWf5Y+wHpfrIGYJSQZ5TGW8bYPTNHz+RcEC++4tcY+A5RXw6RCro+17wFKtu26VGi4buseFHDzwLAkKITCPYmwGOVM5mywTEpiJ43thUQrTn5zGjfXMRMvPApJ/+8lbZ7ylfRJZ6WOFxWyHkp+s6ugRj8NN1kbE9+Jn4vq+mt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YoG/yN1R; arc=fail smtp.client-ip=40.93.194.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZxjRGjtqGEcCUoiATGtgaQf8jVtgzORyMeaE2yHKrG19kt0taDM9fc+0qfx+O7I87zzTsskMnKn7r1RfzmlEbDuL+3cW/wnNhr1zuuWUkevANqWv+6b88BbMzKouKq8akpmcRfEP4FbmRKIx/u9ldI8FSKCDyBuf5S/3ozzED4/Xl7NKdHFaV/x8hgEARPQccTMFdSVcbxU/sRSetnPZFyC74n0CqjmCpmoVwlm4skzglTWSXNRQUFtZE59g46coNFFmxschDb0HMnErpPEKJ0cUgp108+Wcbubw2cgTf3IGqiQuXqN9Mr26Ah4tN8vR7fhnE+0KnT3Mq6oZXkik8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmZymFiEquYYlQi9bZbaC/irfxUdZcYSVrNupY/T5hE=;
 b=wzw9QSDzXayqJBbSYHJdHXv4OgdRH4CSQywqmefCMEBbktqPKHo3e1XzPxl1jObKcKbTbvr57DPMs5PGcYM1U2Gj3dacnGdLRP1ppy7ItiAd6s9RiiQGwX1Ap9KnO++EaIZIICqEhMVfd7pV1gVoDjMxT+zkyp5HNizeton7m4WtxlWgygngaYoi7I7s3fIGppu7+BeDeyqkBgbiGhkZnp42P3AYXluwkABldoU2fwWMFlwR9bwB0heF9FAIYBMD7iVp0gP0XXKtXDIIKhvbz3oq/evMT8rZNXDoWuZDQtfalkOoSwPSwjeDcK7JaHI8gtwiziFVKxetjFMJTV6qHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmZymFiEquYYlQi9bZbaC/irfxUdZcYSVrNupY/T5hE=;
 b=YoG/yN1Rq/V9PmKLuUUG7vSDAc/ZYgvYC+i/W8S2+l3Ys6j5qq7uGeXb6W5LzgFDvfdqbO05G4/ZLlxOyAxFLp2iPOWEvk9qXLkgMGKbr7nPNUT4rIyy64R5NUPpwp//bJjhXCqK5ZiacNx+1l1ZR8SOe4ODTsGBL47NirR5pLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS0PR12MB8768.namprd12.prod.outlook.com (2603:10b6:8:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 18:55:31 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 18:55:30 +0000
Date: Tue, 16 Sep 2025 13:55:26 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-30-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912232319.429659-30-seanjc@google.com>
X-ClientProxiedBy: SJ2PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:a03:505::22) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS0PR12MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 8db6dfd5-0b7e-4b1f-2363-08ddf5529bc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Az2MBLj+2wqwLPdzH2QG/LTimDud4NTnwYotVKZ5HVij4Z05cgd9mjBGEB/?=
 =?us-ascii?Q?aGr5Dp9JKvkfpideTKhYhiHa7Bg9g5fWbsMmz4Em+l4NdCG81ed7oNc35tA7?=
 =?us-ascii?Q?MTXspOT57oaMu4NWYecDoaxQfzV6H0ENpm/Suh8FDdXWrezVlKuLAjWzbREV?=
 =?us-ascii?Q?Mydmp5yfSXPFzUI98uVHdiAPkqRx3VH3ZkxZkGvbePUeBVfs77f9Yuus1q4L?=
 =?us-ascii?Q?4mrG482F5Xy5FnupUow3LC5fOf/da5WnHGL+TnNbQXTiYsH95jzs8IUTuAci?=
 =?us-ascii?Q?f/3tV1ZsG7qvbdOTIQoiXYgw+HqKDa/YzHznkqa/HbFsdw31zvbk6oIuFsBW?=
 =?us-ascii?Q?m9rtrlG3W/SKL6JHZi8o0rCYGDRywv2trnXPsn+0dVg957I1XFNiruDxVnwm?=
 =?us-ascii?Q?lzNJcYssjXWq9t0YVLCraZTJslgT1JUZ+vS+vB89Mp0eIY+VXWWVuqXtQ1XR?=
 =?us-ascii?Q?AWubpHmNPXKo5j2jnNGwRIiyPk08aU1ikl5Op2L+lS7/VSb0BcONFhkewNvZ?=
 =?us-ascii?Q?zAbk/8I5SVbMye4Lq0+puh/AFC5vx8arPT/24JBDBiPTXnLHkv4kcT7IPMHf?=
 =?us-ascii?Q?5QUXUORwAbWRgWzTVhLN01ZeYXyaEpOJ4jwXJh4PZUY4jyKjCTriOSYQUE8Y?=
 =?us-ascii?Q?bOnMZW6bsQKl+riJ/oRICrStIzmxpcydOwgyUT0t+W9sg+46Jg70MjX0boZO?=
 =?us-ascii?Q?WI0EiWzHB5jBdSB5qyBdmDJSvSJ+1lFb/z9LhIYcEx1N098MG8sM7oXuQa28?=
 =?us-ascii?Q?ItBhUQa29BYcJ/moEpLRqzp+IPM8YR/knUbbN4inOI7q7JiYu2fK7dE2iIsY?=
 =?us-ascii?Q?wG9iYaBjX/nftfwjijzmuYpP501i3WmqJ8/D9qkZaSUnHyxSDYvF0BPUjxh8?=
 =?us-ascii?Q?yCOiBEXtGXc4OfZYExPdcX6tQZ7kqU5IALIZFpXGyEXkVVVkJXu0O7eVzsY/?=
 =?us-ascii?Q?PonOWUw+Wm6n9Uwd36dNdMAkXXMP5ZWv27donAq+KBwfDe/31SBlCjEtEK4G?=
 =?us-ascii?Q?OCL13Yu7ZENhQcsmxdDbQ7GBF58IDvmEUQDBhzlp9mSY5s2UQyE3/70o93rq?=
 =?us-ascii?Q?bqml9KX4IbLpr7tqbSeXsr/VhdhOee4oSiZt6suy00f+J0Be4Sm77s9uFstx?=
 =?us-ascii?Q?zkJ0AnAIFr+GkX4vkatOoRsuNL1fNj/mg6LhBQ7Mao0FlgdgNGZDMVBWPoP+?=
 =?us-ascii?Q?4pfYPEUD0rb57HzzDG8KHhoegqc957s2cEX0fj/WWcdIN276yMRgB452K8Lt?=
 =?us-ascii?Q?j+qktYzLRrFFkD8r+rTeyDM8u3u7IxsPCUtM9Q3unYUSXmAmSHS1qtVmgD//?=
 =?us-ascii?Q?5r8ukTEMP1IbORP8SbX60O1FsknZmKP/r8ux4966/83Ssd9t1r40rZIouOgj?=
 =?us-ascii?Q?fdC1/FVcGXXNaNoMZg4GRJPNa9uT6e5DIUHsmKCMsXU+QFIgKg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7XnB8Z/HekyTb+rI8uU9cgVz/0UKv9JorNssFZhWolanwYMUyoLMkJ9PgxN3?=
 =?us-ascii?Q?j1WbAm4cjw6vtV+fB2x3XbT0cmr6MjHruu+XQfyQHtOMeZ7TM7WOTQV110rn?=
 =?us-ascii?Q?PhjDJxDaHLyul7qKk7jsWL+QR1SUQrJEdPq4V3xtbIQzchu1skm1f1ljLF5a?=
 =?us-ascii?Q?5qALv3V5qv2mUZiwMrJ0lg4mnmW6xW6vG6Emt9LiYXDh1sK/aFrh2hFJ/1w/?=
 =?us-ascii?Q?qSM+IQahhirlM6MJd3slsQDDK0xmgK4jh7vlJhT/4slsJggBnJlMz0K7HZK0?=
 =?us-ascii?Q?RmaSjV6BWda+T6QH4bvIgHblQOjB7mkYDzPmU4tvX14OcHpVBQuiZZJwQ1ft?=
 =?us-ascii?Q?GuOpfp3IqaBn/8Uq/eWQvFDZ430NF00fz6JEZ8qX/G1+FRioNySFOCRGt0GM?=
 =?us-ascii?Q?+/Zdy9/lBy+qSMAH9RAlNRQilFwTVKO1sklImW63miSdy0hW05qiokW/Bo2N?=
 =?us-ascii?Q?nQ0Wi0DL+qUqsJqkYxs6xVOhVI8W4Tmat44MAunR6hY1Mj0w39CTIAi+9ORV?=
 =?us-ascii?Q?LONdHjk1Qjh+gkNDTXI4rzJ4saV6IsQp5tNl2Bs2ewzSJLzWLJuTk4Q/KL3a?=
 =?us-ascii?Q?J+o9i4QYoPb2kd0seuOEIBsit+/1NDOzGhllZSMfOeGwjbR3nxjmz7LH4tsV?=
 =?us-ascii?Q?KWZV+Tkz7Bzwjn+GWUH11QzLc7Jei6voGq/FG1/eRRylm+yP07/VVYMAIft+?=
 =?us-ascii?Q?DrG/d+mmsbehJe4kDmvWezZFroMladMrZf7O0sEyLDn+HMezRc2yenkLYl9+?=
 =?us-ascii?Q?A3aRLgswuvEhM5sG937XboLdneh8QjQveaTiBOREl0I5pEK1dfR8ywQlMQHm?=
 =?us-ascii?Q?ljlOuOy6iSjxigGzsTihsLjKOyJkL2A7OZ7PyFCe1TCJMCvgjoz+unsRjkRf?=
 =?us-ascii?Q?TF3EC0Uvvgq14o23WYKq9ELLDsCpY0BsJJhM5kurx9YT1jZPScLcVlfR5nrx?=
 =?us-ascii?Q?eE/cdoWdyhJV2GE4lGppqjJyGnwhQJ5LEf7FewzYq23xNriGhoGQ1f5qc5TK?=
 =?us-ascii?Q?RPueA2fUqIuvx8tD7pqEhxTF5qrqycnhjE5pWrh4fU2feFEZ66f2L2KzcMyB?=
 =?us-ascii?Q?isExfNGJCjH6qRHOfdkhSlbe3lcK8UdDT9A7lTygQyqFR5Sq7Y/yDaW/LzaM?=
 =?us-ascii?Q?FaZi7glw+ZRw21fa3Ki6XAWJbxT+ntC2WYZ1KL4Z5y1fEdJtbNh4AmoFUY3p?=
 =?us-ascii?Q?SpcTUoG6xukXW68ncweIlZIFe0FOZ60QGw8+AQNIurtJClrB0i7GxEslFs7a?=
 =?us-ascii?Q?bKvcxln5p7kuZ6xzzPurJODqsVSLVnw8+FQhq++GLg+nfjhDVod7Uuspcmgs?=
 =?us-ascii?Q?1thkGC1xZltSPdst7Oi19VPgN1XVq9elGqYIiX4kST1k10fLom9p/cdRNKNO?=
 =?us-ascii?Q?+RD4+PSsHb6WPGBAd+wJTQWgpSnx5BvPpQfonrZu83wAn8P/J7sQo+VK/mNp?=
 =?us-ascii?Q?SX3dA2BJhJtKWdLskYegE/dRxVpHlvWaDUGvh9B+2H2ZE5juL+nuMkzpn6jt?=
 =?us-ascii?Q?uOkiGu4+dJ4nDa6fDT7HJfQjlQM970qLIk4kcEaZAtdv0OCVxk3zRP3w3RH1?=
 =?us-ascii?Q?HfBGPQhZ13LptzRgl7SK3UdIbQL049aae1URL2oc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db6dfd5-0b7e-4b1f-2363-08ddf5529bc5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 18:55:30.7977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jgLAZIbPrBAhHzZB7kuKnUqf2WjAHJASZ2/ZsT/Vq1jIqY/9CPYsAlnwZzKlXnm/SV31XFtKg5tkKXchgfwwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8768

On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> Synchronize XSS from the GHCB to KVM's internal tracking if the guest
> marks XSS as valid on a #VMGEXIT.  Like XCR0, KVM needs an up-to-date copy
> of XSS in order to compute the required XSTATE size when emulating
> CPUID.0xD.0x1 for the guest.
> 
> Treat the incoming XSS change as an emulated write, i.e. validatate the
> guest-provided value, to avoid letting the guest load garbage into KVM's
> tracking.  Simply ignore bad values, as either the guest managed to get an
> unsupported value into hardware, or the guest is misbehaving and providing
> pure garbage.  In either case, KVM can't fix the broken guest.
> 
> Note, emulating the change as an MSR write also takes care of side effects,
> e.g. marking dynamic CPUID bits as dirty.
> 
> Suggested-by: John Allen <john.allen@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 3 +++
>  arch/x86/kvm/svm/svm.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0cd77a87dd84..0cd32df7b9b6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  	if (kvm_ghcb_xcr0_is_valid(svm))
>  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
>  
> +	if (kvm_ghcb_xss_is_valid(svm))
> +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> +

It looks like this is the change that caused the selftest regression
with sev-es. It's not yet clear to me what the problem is though.

Thanks,
John

