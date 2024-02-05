Return-Path: <kvm+bounces-7980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0266884965E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5B61F220EF
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C750712B6C;
	Mon,  5 Feb 2024 09:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZcpKSBmp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29329125D3;
	Mon,  5 Feb 2024 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707125028; cv=fail; b=r1qOy9h/qHzxVtIByiA/Sg25iF2F4nPqt9cLF1qjWTzk104u3zRBSuBdhk63JkBRIKXzXknzyGmhs5wuQUEX6DQCOzllJjlahUCAa++olDO8IePoGSc6O8EUef1LhzD72hiBTG8uaQhQbXO/BNUZ4I/bz+NJZe6dx4IQ+tInSrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707125028; c=relaxed/simple;
	bh=NmfhOJiZ4/7SPicZnvcsoS7/XTBeZaZ11l40ZWuS/Uw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YyfcluYeqHsmBIZf5SGHCtBvgrKOqCUES4TIBsLiAbOCj7vMJwIdTp5L9fR9+UE7ILbV3Ov4EcXV7DZnhxa6lgbgNWUb94Kq5l5oaTiibZfnj4M2ILnJ/REdW6G4IbzJXULPJ36bKq5xLS6482fMK+kPs7kPlc6wFBqIQz69cOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZcpKSBmp; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuDsvhxbJy8s55C1TNwgTHT1ePZIV+pf7R2nGsTNIkqOZCaBGNVP2jipGit1YKAqD9Pav4337Ga3HHmUkuTOXyWCQ7GVimZnxC/mG7nRclL9/PZ2xiDNu01r80wDYbiMXoaaSj3wQTIgFZp2no+LapxxUV/TUWIdEt6rwtwSA7Eg4LNjCzoMjVuAJiVu8BFkFP6yhOYC/B4PxBjgc42bPsuyr6Qt2CHhC17PTuhUT+Gk923ycMJ3LbigkZj7XYFe/hTiJb+q3UF36ti/SGj1PfOzk2kINyfnRA0ET75F8kN8hguw1TZ5yiSo2JgGtf2TC0BdFQ3zmU7Txnr3msTNcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsboIaf4fMYE7R3WVn11b6LkpuZKXsPhWY+VUeDxX2c=;
 b=H0DVTqO8vE6rV5rE/B1CcPnp1jqn0MAW0JwIp/PYowXYGAOwC80jgJnK8bDijhsbd6XqYrdAv1XLTHK9eaiKOOfdHs7AwxXo9yacSlugemat1RPXf82cgYiie9ggTpkVvTMtamPaEd+KTzpbkjeD/Wzx3dHfvb+H6qlxRnIKpPmiQ4dChgieKYuGp3nasoAFwm58ElF0Cm4YKkJmzFLUnRFn+oWPRGDzOD7QBbc9w/KojjREXwGANR2+pny17GrKA2jfnDor0uXLxw1mS76tqucfEPnLhkBrYUo7iWhyeJQspJsSKa85tA5br6F+Y2oUkx9BqCgSq89FDnCERFueJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsboIaf4fMYE7R3WVn11b6LkpuZKXsPhWY+VUeDxX2c=;
 b=ZcpKSBmpHw56tTcgg4CfFcJkbH3doBO26xpDVyO9rtgkTki/eVUVm959Cw0F82TsJtOiKHzPPfUyyzinW5CXrAU3l2KWMUOHElIhjOLgq/TZYpAGCBiiUkJ3exUhZvWhMbSerwoZYmIwiwmTfemo+rpEwByP+oWd2xfpCqOfAGc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB8025.namprd12.prod.outlook.com (2603:10b6:806:340::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Mon, 5 Feb
 2024 09:23:42 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7270.012; Mon, 5 Feb 2024
 09:23:42 +0000
Message-ID: <ec2be3f2-b20a-46c1-815c-9065e10f292a@amd.com>
Date: Mon, 5 Feb 2024 14:53:30 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
 <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
 <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>
 <20240201140727.GDZbuln8aOnCn1Hooz@fat_crate.local>
 <408e40b4-4428-4bef-bb96-8009194a9633@amd.com>
 <20240202161455.GCZb0U_9jckCT8loBc@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240202161455.GCZb0U_9jckCT8loBc@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::23) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: aa62f94c-47ae-4b59-b290-08dc262c24b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d/yGDjz69p0Uuhp1R2ATaP46Q/wpO1iCMB6sYCuhMwvKTWpGpmWjimK83qOhqwZbwqZrvrKrBkTRcXALJkza5IQlCAJfShujwSkwbxA4B429mH6akjAAnN8gQ++ggtRMIhAYLLEzfr8/sqBJsKOvxiaeEvdKBYEpwH+KRM3QFuPoGdYgUwg2qHifWhLUyXb1/w9vd5dPWwlQ2XQAVnGQqRyglBccltnpqBcqIpbVAw3Qjw2p9bNnqHY5XRbB3BEhDIyHprQ1ltGCnbXXnT018riZQJXgotm9XfvLsA8SY5hoiC1lcpfb4VOacOwX48ObYgx6ge/I7PHQVxzEylFlkLQ60acIHDsVKkwXlwyWqYEKMT6umPPH41Pr3A0l7DFM3pFEYPs9+mKCxuep/Lg2N+FhcJlcSOtcmp3nb9IOeT+EJcRHTWbqeMpmge8cmkrsybHH5EEsYHH4Vc5LyrMLQ1qP0Ltt3MDhvPKtzsx2huJiK4idJ7cHpSyfVUk5Ywk+gN0jwOopbWJ0RNNXjFCzRNjoUB46GBpUilmQdJdQPJJR/Vp7+ff1X5HCMWmu+FxfSPjiEI0q+aUgNoFoHaBW/zDVVHjPoOw8R16YBksvFoggkadXiU1103SgKf6CRKgkBd9FP2+hAastfPtVZRTLvaDk+O7lNlwgacabEp1D8VDc7kL+Ncp89Zojd/iFCCE2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(136003)(376002)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(31686004)(41300700001)(83380400001)(36756003)(31696002)(5660300002)(8676002)(8936002)(7416002)(2616005)(26005)(3450700001)(6512007)(38100700002)(53546011)(4326008)(2906002)(966005)(478600001)(30864003)(6666004)(6506007)(66556008)(316002)(6916009)(66476007)(6486002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFZSVTBCb1FJTmFPbndGaXg2cDBqeFgybmpjTjhCZlpxd2NpZjB6dXc0bnhi?=
 =?utf-8?B?a1RhK0dqd2lsUGhLY2FBRk55WXMxekhTV3VEdjFzRzZvTmdURG9DQkUvcENK?=
 =?utf-8?B?SkpzeElCNXJHKytJK1lqeHF5U2tMM2hTdVdTbEFSRC9xcUxEVllST3l1YnVZ?=
 =?utf-8?B?bE1WQWNjSHdWMDVtaWdRVTdGUFFtYXlDblNZbktNWS85NFh6QWR0K0V6MjRq?=
 =?utf-8?B?UWdEZ0VTTDh6MFBPdnFPY1prQzdTRS9Dald1MHlqMHZ1YUR0OVJDdnFGV3ZF?=
 =?utf-8?B?UGZzR0VrWjRTOStiemZIVFFKZDdiblI5djZkdTNtVVY0RkJDS01CQ1pGWG11?=
 =?utf-8?B?TkZrSzMzK0dHc0YzMTRsZ3Z0WEx2UWdLYzJUN2haL3RMb1d5ZnJGeFpvcXJX?=
 =?utf-8?B?OU55NHhRWngvK2pMQVJWSnlSbG1peFlLZlFQZGt1MjRmbW9zK1hEWnJuVzFy?=
 =?utf-8?B?ZHBTS0tXQlNOeDRpOWdwSWtlZDdNMTRNeHdrc2xBUlQwNnlZTUN2ejltMVZC?=
 =?utf-8?B?NjRBRzZSMjVINWgrYVRmUzV5K0pIOXZDMlN0NWdkV2Qrd0lJSlZuQjd0SHF6?=
 =?utf-8?B?U2JiZjhnV0R4dllycXM2czd0cER3WTQ3aFpiMjhkc1p5b0d5ZWxiTXFOdWRD?=
 =?utf-8?B?T0c2UTAyQ2xXd0Rob2gvY3Zyd21zZnUzYk1Lek1zYThtNGRnTGluc2htRlFY?=
 =?utf-8?B?TDBYYXVPdHU3WXRVVWliYWhkOFJ1czRiTnZzWjR5N2tyQVBsVC9ZdjBoQ0h0?=
 =?utf-8?B?cmdNd0VCeWZsU1A3dkRmNTlqTWxOV2xFMTl3SmcxbEhpQUZ3NFh2dnhLMkd2?=
 =?utf-8?B?WHBXNmpZU1EzdFRHUE9OUkdwalQrMVRCM01ZdzRhVnAxeXpJODlqV2g5WEx5?=
 =?utf-8?B?aVRqS2prUk04ZUtOblY5RHgrVmM0cWhRMFVTdStoRUd5YkFRdGhaclB0MGoz?=
 =?utf-8?B?R24rZUF1MDFHTGxNN0lVMFVYYlliRnRkVGhtQnlqRXhBRldsbDZORlR1OUkw?=
 =?utf-8?B?SWt1a3VESlVWMU8yY3BmalFMc1VRUlRpUGdjcHVoNGtGM0hpUVRXUWRwK2dM?=
 =?utf-8?B?L2pwMG1JRVplbWxGeHU3eDlQajQ4OW01M2VOcFpZTmhLakRIZGQyRCt4a3Bv?=
 =?utf-8?B?VTBnZE5wL3B4RXRKWjhBckRMemQvMWdleFlXT2ZqbUpzZFlKVGgwQjNvNVg2?=
 =?utf-8?B?V2Q3RWRsR3Jha3g5cjNiTUU0V2FzTi9LUkxMR1E1S1dQcG5MVXZheVNOSXo1?=
 =?utf-8?B?MzlwK0ZjU2VCa1l6ZlZUNlVrUFFSYjNMdGJmdUFhNEFZY2dObHZMZlp5U0Ni?=
 =?utf-8?B?U1RBd09zTWN3WmU0dG5JT2VzMWUrVnJNRUxqV3pmOVoyejFHd1ZKOFovU0Jy?=
 =?utf-8?B?KytLV3dIZ1BsdVg3L1pGRWxjQzdNSnFoNHVtQ2RhL0RzOGhjNU9YTDF3c3d2?=
 =?utf-8?B?eVJ0RjlqYjBGVkRmY040RTVQbTNGc1NXMldabTlVaTlmZU1rVEtVN3dIb2Q0?=
 =?utf-8?B?NE1PT3gralpnTWpRMlZTV0MrRjRNRWhYMUM5UWpncXJFVHBiVldPK0dkUTlz?=
 =?utf-8?B?K1RJM2E5bGRWQTJHNW8vejFiMTdhcERiUXN2K1YzTEFNZnZCbVZieTczUkJm?=
 =?utf-8?B?bGJqZFJ6aWtHdHQvTytONlkrZjY4Z0VOQm1XZTMzODM1OVRVV0Nrc0phMkZt?=
 =?utf-8?B?SC94ZWZYTmN2L0laeFVicTdmem5EcFFOVVVKRFJjNlV1SjIrQTJxSVFMaEVJ?=
 =?utf-8?B?eitib3dSYWdZalpFaGhheWxPTE5ZM2tkQXBGU0pqR0Z6dHJ3bGxzNW8wZFNE?=
 =?utf-8?B?eGY0ZXJRRnZxRG5CS0gwRnpEQXc2SkZ1WGVJNnpCMUZCNGdFSlY4ZHAwL250?=
 =?utf-8?B?ajNXOVV5VGxnMUlNVzRvNjVSMktNM0VhT0N4SVR3aW1mYjNPSDFrdmlvNlY5?=
 =?utf-8?B?ZG1HMUNDdTd6aWptbFlnYzZsV1VHRk42SGl2bi91a285S0h4Vjh4OTNwZm9D?=
 =?utf-8?B?cE9ZTU92SnZQSEFLRmRiR09kK3QyRk0zT1VsWDVsaWZHSEl3R0dWZEwxeHNi?=
 =?utf-8?B?MGl4RzVoeE1SSWJIeUppbVcvVzc2cmFCbG9LaVduNy9LRDRYb2s5VjdNZnFE?=
 =?utf-8?Q?1dEQGAenxfy4yhU5seGrECnbn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa62f94c-47ae-4b59-b290-08dc262c24b9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 09:23:41.9910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HdZADG1061faEoAb9KKDQlAvLQBlx+SuaZRtEuHqi0sG7urmyhdK8JHFLQvXFMoJ+QNGqtfaKG88yQO+dCYTjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8025

On 2/2/2024 9:44 PM, Borislav Petkov wrote:
> On Fri, Feb 02, 2024 at 09:20:22AM +0530, Nikunj A. Dadhania wrote:
>> I have opportunistically moved the header in this patch as I was
>> adding guest request structure. Movement of rest of the functions
>> implementation from sev-guest.c => kernel/sev.c is done in patch 7/16.
> 
> And kernel/sev.c has a corresponding header arch/x86/include/asm/sev.h
> which is kinda *begging* to collect all the stuff that sev.c is
> using instead of introducing a sev-guest.h thing which doesn't make
> a lot of sense, TU-wise.
> 

Sure, below is the updated patch. Complete series is pushed here 

https://github.com/AMDESE/linux-kvm/commits/sectsc-guest-latest/

Subject: virt: sev-guest: Add SNP guest request structure

Add a snp_guest_req structure to simplify the function arguments. The
structure will be used to call the SNP Guest message request API
instead of passing a long list of parameters.

Update snp_issue_guest_request() prototype to include the new guest request
structure and move the prototype to sev.h.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  75 ++++++++-
 arch/x86/kernel/sev.c                   |  15 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 194 +++++++++++++-----------
 drivers/virt/coco/sev-guest/sev-guest.h |  66 --------
 4 files changed, 186 insertions(+), 164 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5b4a1ce3d368..56b07c79945a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -97,8 +97,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 struct snp_req_data {
 	unsigned long req_gpa;
 	unsigned long resp_gpa;
-	unsigned long data_gpa;
-	unsigned int data_npages;
 };
 
 struct sev_guest_platform_data {
@@ -140,6 +138,73 @@ struct snp_secrets_page_layout {
 	u8 rsvd3[3840];
 } __packed;
 
+#define MAX_AUTHTAG_LEN		32
+#define AUTHTAG_LEN		16
+#define AAD_LEN			48
+#define MSG_HDR_VER		1
+
+/* See SNP spec SNP_GUEST_REQUEST section for the structure */
+enum msg_type {
+	SNP_MSG_TYPE_INVALID = 0,
+	SNP_MSG_CPUID_REQ,
+	SNP_MSG_CPUID_RSP,
+	SNP_MSG_KEY_REQ,
+	SNP_MSG_KEY_RSP,
+	SNP_MSG_REPORT_REQ,
+	SNP_MSG_REPORT_RSP,
+	SNP_MSG_EXPORT_REQ,
+	SNP_MSG_EXPORT_RSP,
+	SNP_MSG_IMPORT_REQ,
+	SNP_MSG_IMPORT_RSP,
+	SNP_MSG_ABSORB_REQ,
+	SNP_MSG_ABSORB_RSP,
+	SNP_MSG_VMRK_REQ,
+	SNP_MSG_VMRK_RSP,
+
+	SNP_MSG_TYPE_MAX
+};
+
+enum aead_algo {
+	SNP_AEAD_INVALID,
+	SNP_AEAD_AES_256_GCM,
+};
+
+struct snp_guest_msg_hdr {
+	u8 authtag[MAX_AUTHTAG_LEN];
+	u64 msg_seqno;
+	u8 rsvd1[8];
+	u8 algo;
+	u8 hdr_version;
+	u16 hdr_sz;
+	u8 msg_type;
+	u8 msg_version;
+	u16 msg_sz;
+	u32 rsvd2;
+	u8 msg_vmpck;
+	u8 rsvd3[35];
+} __packed;
+
+struct snp_guest_msg {
+	struct snp_guest_msg_hdr hdr;
+	u8 payload[4000];
+} __packed;
+
+struct snp_guest_req {
+	void *req_buf;
+	size_t req_sz;
+
+	void *resp_buf;
+	size_t resp_sz;
+
+	void *data;
+	size_t data_npages;
+
+	u64 exit_code;
+	unsigned int vmpck_id;
+	u8 msg_version;
+	u8 msg_type;
+};
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern void __sev_es_ist_enter(struct pt_regs *regs);
 extern void __sev_es_ist_exit(void);
@@ -209,7 +274,8 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
@@ -233,7 +299,8 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
-static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+					  struct snp_guest_request_ioctl *rio)
 {
 	return -ENOTTY;
 }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c67285824e82..3d6429321536 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2170,7 +2170,8 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2194,12 +2195,12 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	vc_ghcb_invalidate(ghcb);
 
-	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-		ghcb_set_rax(ghcb, input->data_gpa);
-		ghcb_set_rbx(ghcb, input->data_npages);
+	if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+		ghcb_set_rax(ghcb, __pa(req->data));
+		ghcb_set_rbx(ghcb, req->data_npages);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
 	if (ret)
 		goto e_put;
 
@@ -2214,8 +2215,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
-		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-			input->data_npages = ghcb_get_rbx(ghcb);
+		if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+			req->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
 		}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0450c5383476..894f6974e192 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -28,8 +28,6 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 
-#include "sev-guest.h"
-
 #define DEVICE_NAME	"sev-guest"
 
 #define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
@@ -169,65 +167,64 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *resp = &snp_dev->secret_response;
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
-	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
+	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
-		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
-		 resp_hdr->msg_sz);
+		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
+		 resp_msg_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp, snp_dev->response, sizeof(*resp));
+	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
 
 	/* Verify that the sequence counter is incremented by 1 */
-	if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
+	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
 		return -EBADMSG;
 
 	/* Verify response message type and version number. */
-	if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
-	    resp_hdr->msg_version != req_hdr->msg_version)
+	if (resp_msg_hdr->msg_type != (req_msg_hdr->msg_type + 1) ||
+	    resp_msg_hdr->msg_version != req_msg_hdr->msg_version)
 		return -EBADMSG;
 
 	/*
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
-			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
+	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
+	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
+			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
 		return -EBADMSG;
 
 	return 0;
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
-			void *payload, size_t sz)
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &req->hdr;
+	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
-	memset(req, 0, sizeof(*req));
+	memset(msg, 0, sizeof(*msg));
 
 	hdr->algo = SNP_AEAD_AES_256_GCM;
 	hdr->hdr_version = MSG_HDR_VER;
 	hdr->hdr_sz = sizeof(*hdr);
-	hdr->msg_type = type;
-	hdr->msg_version = version;
+	hdr->msg_type = req->msg_type;
+	hdr->msg_version = req->msg_version;
 	hdr->msg_seqno = seqno;
-	hdr->msg_vmpck = vmpck_id;
-	hdr->msg_sz = sz;
+	hdr->msg_vmpck = req->vmpck_id;
+	hdr->msg_sz = req->req_sz;
 
 	/* Verify the sequence number is non-zero */
 	if (!hdr->msg_seqno)
@@ -236,17 +233,17 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
+	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-	aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
-		       iv, hdr->authtag);
+	aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
+		       AAD_LEN, iv, hdr->authtag);
 
 	return 0;
 }
 
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	unsigned long req_start = jiffies;
@@ -261,7 +258,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -271,8 +268,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
-		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+		override_npages = req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
 		 * Override the error to inform callers the given extended
@@ -327,15 +324,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	}
 
 	if (override_npages)
-		snp_dev->input.data_npages = override_npages;
+		req->data_npages = override_npages;
 
 	return rc;
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
-				struct snp_guest_request_ioctl *rio, u8 type,
-				void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz)
+static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				  struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
 	int rc;
@@ -349,7 +344,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, req);
 	if (rc)
 		return rc;
 
@@ -360,7 +355,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memcpy(snp_dev->request, &snp_dev->secret_request,
 	       sizeof(snp_dev->secret_request));
 
-	rc = __handle_guest_request(snp_dev, exit_code, rio);
+	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -369,12 +364,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
 			  rc, rio->exitinfo2);
-
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}
 
-	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
+	rc = verify_and_dec_payload(snp_dev, req);
 	if (rc) {
 		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
@@ -391,8 +385,9 @@ struct snp_req_resp {
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_report_req *req = &snp_dev->req.report;
-	struct snp_report_resp *resp;
+	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_guest_req req = {0};
+	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
@@ -400,7 +395,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(report_req, (void __user *)arg->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/*
@@ -408,29 +403,37 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_REPORT_REQ, req, sizeof(*req), resp->data,
-				  resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = report_req;
+	req.req_sz = sizeof(*report_req);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &req, arg);
 	if (rc)
 		goto e_free;
 
-	if (copy_to_user((void __user *)arg->resp_data, resp, sizeof(*resp)))
+	if (copy_to_user((void __user *)arg->resp_data, report_resp, sizeof(*report_resp)))
 		rc = -EFAULT;
 
 e_free:
-	kfree(resp);
+	kfree(report_resp);
 	return rc;
 }
 
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_derived_key_req *req = &snp_dev->req.derived_key;
-	struct snp_derived_key_resp resp = {0};
+	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
+	struct snp_derived_key_resp derived_key_resp = {0};
+	struct snp_guest_req req = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -445,25 +448,34 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp.data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(derived_key_req, (void __user *)arg->req_data,
+			   sizeof(*derived_key_req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_KEY_REQ, req, sizeof(*req), buf, resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_KEY_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = derived_key_req;
+	req.req_sz = sizeof(*derived_key_req);
+	req.resp_buf = buf;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &req, arg);
 	if (rc)
 		return rc;
 
-	memcpy(resp.data, buf, sizeof(resp.data));
-	if (copy_to_user((void __user *)arg->resp_data, &resp, sizeof(resp)))
+	memcpy(derived_key_resp.data, buf, sizeof(derived_key_resp.data));
+	if (copy_to_user((void __user *)arg->resp_data, &derived_key_resp, sizeof(derived_key_resp)))
 		rc = -EFAULT;
 
 	/* The response buffer contains the sensitive data, explicitly clear it. */
 	memzero_explicit(buf, sizeof(buf));
-	memzero_explicit(&resp, sizeof(resp));
+	memzero_explicit(&derived_key_resp, sizeof(derived_key_resp));
 	return rc;
 }
 
@@ -471,32 +483,33 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 			  struct snp_req_resp *io)
 
 {
-	struct snp_ext_report_req *req = &snp_dev->req.ext_report;
-	struct snp_report_resp *resp;
-	int ret, npages = 0, resp_len;
+	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+	struct snp_guest_req req = {0};
+	struct snp_report_resp *report_resp;
 	sockptr_t certs_address;
+	int ret, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
-	if (copy_from_sockptr(req, io->req_data, sizeof(*req)))
+	if (copy_from_sockptr(report_req, io->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/* caller does not want certificate data */
-	if (!req->certs_len || !req->certs_address)
+	if (!report_req->certs_len || !report_req->certs_address)
 		goto cmd;
 
-	if (req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
-	    !IS_ALIGNED(req->certs_len, PAGE_SIZE))
+	if (report_req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
+	    !IS_ALIGNED(report_req->certs_len, PAGE_SIZE))
 		return -EINVAL;
 
 	if (sockptr_is_kernel(io->resp_data)) {
-		certs_address = KERNEL_SOCKPTR((void *)req->certs_address);
+		certs_address = KERNEL_SOCKPTR((void *)report_req->certs_address);
 	} else {
-		certs_address = USER_SOCKPTR((void __user *)req->certs_address);
-		if (!access_ok(certs_address.user, req->certs_len))
+		certs_address = USER_SOCKPTR((void __user *)report_req->certs_address);
+		if (!access_ok(certs_address.user, report_req->certs_len))
 			return -EFAULT;
 	}
 
@@ -506,45 +519,53 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, req->certs_len);
-	npages = req->certs_len >> PAGE_SHIFT;
+	memset(snp_dev->certs_data, 0, report_req->certs_len);
+	req.data_npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
 	 * The intermediate response buffer is used while decrypting the
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-				   SNP_MSG_REPORT_REQ, &req->data,
-				   sizeof(req->data), resp->data, resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = &report_req->data;
+	req.req_sz = sizeof(report_req->data);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+	req.data = snp_dev->certs_data;
+
+	ret = snp_send_guest_request(snp_dev, &req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		report_req->certs_len = req.data_npages << PAGE_SHIFT;
 
-		if (copy_to_sockptr(io->req_data, req, sizeof(*req)))
+		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
 			ret = -EFAULT;
 	}
 
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
+	if (req.data_npages && report_req->certs_len &&
+	    copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
 
-	if (copy_to_sockptr(io->resp_data, resp, sizeof(*resp)))
+	if (copy_to_sockptr(io->resp_data, report_resp, sizeof(*report_resp)))
 		ret = -EFAULT;
 
 e_free:
-	kfree(resp);
+	kfree(report_resp);
 	return ret;
 }
 
@@ -868,7 +889,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	/* initial the input address for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
deleted file mode 100644
index ceb798a404d6..000000000000
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- *
- * SEV-SNP API spec is available at https://developer.amd.com/sev
- */
-
-#ifndef __VIRT_SEVGUEST_H__
-#define __VIRT_SEVGUEST_H__
-
-#include <linux/types.h>
-
-#define MAX_AUTHTAG_LEN		32
-#define AUTHTAG_LEN		16
-#define AAD_LEN			48
-#define MSG_HDR_VER		1
-
-/* See SNP spec SNP_GUEST_REQUEST section for the structure */
-enum msg_type {
-	SNP_MSG_TYPE_INVALID = 0,
-	SNP_MSG_CPUID_REQ,
-	SNP_MSG_CPUID_RSP,
-	SNP_MSG_KEY_REQ,
-	SNP_MSG_KEY_RSP,
-	SNP_MSG_REPORT_REQ,
-	SNP_MSG_REPORT_RSP,
-	SNP_MSG_EXPORT_REQ,
-	SNP_MSG_EXPORT_RSP,
-	SNP_MSG_IMPORT_REQ,
-	SNP_MSG_IMPORT_RSP,
-	SNP_MSG_ABSORB_REQ,
-	SNP_MSG_ABSORB_RSP,
-	SNP_MSG_VMRK_REQ,
-	SNP_MSG_VMRK_RSP,
-
-	SNP_MSG_TYPE_MAX
-};
-
-enum aead_algo {
-	SNP_AEAD_INVALID,
-	SNP_AEAD_AES_256_GCM,
-};
-
-struct snp_guest_msg_hdr {
-	u8 authtag[MAX_AUTHTAG_LEN];
-	u64 msg_seqno;
-	u8 rsvd1[8];
-	u8 algo;
-	u8 hdr_version;
-	u16 hdr_sz;
-	u8 msg_type;
-	u8 msg_version;
-	u16 msg_sz;
-	u32 rsvd2;
-	u8 msg_vmpck;
-	u8 rsvd3[35];
-} __packed;
-
-struct snp_guest_msg {
-	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
-} __packed;
-
-#endif /* __VIRT_SEVGUEST_H__ */
-- 
2.34.1



