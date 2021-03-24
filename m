Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB316347EC2
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbhCXRGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:06 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:33120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237064AbhCXRFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Skg/rKVq66h4a0lz7YWpeLJ8DdO8FGjyBACA1WJ1NiHNcWbTuIgiAthIN/WtmxvSk29QRPsrM927sqMvp0kPBooiH9Me8pRdHekE8xcDV8c2nDT8MOdQtb2hzNhKCKu3Fn25P7bhHMynslY7nz2c9Ek1+39c91AP4arkfFzjoIuLxJJwKhHekRxR8+60JVTLgF3MCMJhz4OfEzjA/X0eatNyVnsAwA4EpZvRgx/Ky2CESZ0DkUFGWvwJCTw0j33XWbJRDV99geybHfizlO0eSeStgj4+dQLRCSnG6xmYFgEAFn47lYqezZrsXN3GaTsVhTehf1+ca3e+tScKGpNM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRup7kY4fRGY3mEwn4QZs1gDzyCYuXw7CLdv8NxS2q0=;
 b=Iqpi5veuZQBPZEn+VIzB9zI0OwtuOjCK13OaelLmXj3Yj8KH8K5Z1c2NqFIKU1Y3Yuy6Qqrop7eIwYkyPwWFa8rk3ltTV5jELpzed6nzUrkc7pa7MQfyUZi197s+AiVItu2nWSzUs3Ejm7PIsmf5Hnr15E5uuJf/pMrd4eN3aqH8lfoaCiQ5b13gt6pQktvEBYDz2aehXfYggx9qKgtTesLf1GqDXt1JPM2TYcZGwiUVJOGwQYDa1hztGaJwOz4Inh9HxtuDME1Nfg5+ijwkR6/CyeKwRY+TkXZKSAM6EqRlJ0CHxZ8EKRf++MzZdGSZ8kTUOWZ+Y7jH6JNi0WKCuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRup7kY4fRGY3mEwn4QZs1gDzyCYuXw7CLdv8NxS2q0=;
 b=BDvIkjzvxCaRulah1FFHKJT80iyWRG8MjBivfq5WOyuzymeqPJa/0z0SBdikK8D4E1DFg0rORxrfPwbCd6m1HzjpLD4A8zHde2wq/fLB//AJdwxh1yiJWOZyRjBBGx77pLDKV896MYXprqsUPUqJWzpJHXezDWfOG//DwRlZm6M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:11 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 24/30] KVM: X86: define new RMP check related #NPF error bits
Date:   Wed, 24 Mar 2021 12:04:30 -0500
Message-Id: <20210324170436.31843-25-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35b5b1d2-6d69-401d-b35d-08d8eee6fbd8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438202ED3BE11F814984A9BCE5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9WalZLa9Sa0ASb3oZ8Dq9UUDsySh0w79yNjaJwNjTxsFJrTzyrA7h0a3JPOwEm5olUugcQjnIdQDoFy9nbZiAwnleUJyySbVS6XcN1LXb6YpwHc7VhqhHKuz8vfbF7nuRcr3a2cQBeg6oe0464gBKEVGhhvVLCpTXsEV6+z7/Doddi2oq+5UsS+klMnY9JRpsTBpfi4Exrju+62M1jKblfmDdWBnyjGvL4qvssoYomgBenXKvtQiAZkIKbyaQxm+yJ+lx1oOpDPkom+xqNszrVBJhEKiRK3tS6syWwC8188NYPmP9pP3eMwjKOlPvJxhwvFYO3l29khqRKDtC0+habyhkhOMeWN9zF9nDzWxznE/xNMBTAPE45SjhWfmgaPWasknilcKf9CVjXRurPdTohMgu8kPSp9gePzqkWi6p0j5tAb3fJy0FKg6MSE8CFqGYeHifib1EoWrPEbAUINBi8VQXMZ/ip1eUgQn/APXNi1Ife5lMbuHi6LMBmMmL2r1PoZ0oKV6r/3EKJ9JM9hIVa64+lgpflu+eInx4NTVd/rhPwxDTHtaYixBvkja4xtQJdsmo64qMsLtHSrm75WzIr4NkxtidOK2XFaXNlDYNk2RtDySjax2o0gwPXOVs1hQ5qJSbJzQuk52qcxpz9V5aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?stwoRDOQ/QAyDOBDF81I6E5m1kikqeIzlLdfQocm2kbvUC2k32rCbWEwVlOa?=
 =?us-ascii?Q?bafgbkgFpKp6xdIgqhbF4HothekrAi33u8WyVGccofWtx2C7N9u8QuoKPKe6?=
 =?us-ascii?Q?NtONsUXVuykRKGoGOmwOQIjHZVhYaEOOXLhjlRwUOa6byAKMSrgU377QQ0LH?=
 =?us-ascii?Q?d5NDFpyqMIe9ag4G9GtWV69MGLF4b+oFcvzHpBKqi35rZZ4suADD45hxwea5?=
 =?us-ascii?Q?KfO8SjplrgOgJpw/Xi88A/cmW0ywbyv6UvK+qRPLXN4hagnU/NfWzMiWW2sD?=
 =?us-ascii?Q?+D59rJp/ShmWoEjiOqLSwYAZFPxX+RU8mJCw9hUN7NOPvtK2/CpPcjTPFtmg?=
 =?us-ascii?Q?KcPjL3H/gVFh0KQ2RnROXzsJVq3k3UCFSIY+i0FS17M71q811+A0YdUaWNpc?=
 =?us-ascii?Q?UYacAYdjzAa94dvG7+nJWf8C3/65E/JL/VN6mOxv3+Wvg4UUnFeQjSF8j/gY?=
 =?us-ascii?Q?DB2qSJiMx4fSCm9rxShVQBO/nVPJejQWyrlMmHEWO6/xjQsHMuJPE6pVVs9n?=
 =?us-ascii?Q?MHfWqLXbnQ98iuYuQtWHR4raF95vD352FA38QkMGDCyPZRANYbC7DOwRf0AO?=
 =?us-ascii?Q?tHq3R+422m5iiK13/fl571yzVvEK6RXKxRUUPgSuhqttpBZt4ktYI0nfSYZO?=
 =?us-ascii?Q?hZF4rxc3RXl2M97J5dFNzg7VV88oghxWAm2gIKtRMfxoQsXXU/IqzbUvP5r8?=
 =?us-ascii?Q?k9igOcF1x4xA4Wx371jAmf5OuU01igncw2Xwc3wkahfGKZoJOyFlbBmhNEom?=
 =?us-ascii?Q?7mh05wTJK9VyQ1BxcngFYMLq/L+LvUR2mUigj/KRxRAbyZNLjkGVRypx3uUI?=
 =?us-ascii?Q?uDW2pzvUSNvd/e5hr+yQziKkK5J+R9NBpUzbhGc/WUIw0w+uLku9nw5+FhV0?=
 =?us-ascii?Q?AcYxMjpS0ETsWH18PCQ43GYJpVkfKe9ABysXFftG5tlsOFFZ4eARFZyCCx8y?=
 =?us-ascii?Q?VGFCAAW494AyoK3631EpqBD/3pJzlgYF59Floo7hUshTzJ5a9CRbUf1LvRCl?=
 =?us-ascii?Q?DVsr5q50vxz5mQFP5pWpq+yHU1OE3Ds12Ytt416jWxO+VT4FTi4ZzWBHNMS0?=
 =?us-ascii?Q?fPxRtT2pvtowH7kU7ZsVF3wWjVBFnqtP2okLV2eVjChLdZiwEiNXy6UiGH49?=
 =?us-ascii?Q?q8bz5zV3cSe5pLeUaj0I2pa9OI0aZluKAYSzr9yqbWMTwraXn+44qq5cNfxJ?=
 =?us-ascii?Q?CwbmG5EThdP4mIb9B3pCDwuakfNyZsVKc7RF5vhAxMYSFdNzS8qPVLO22SVq?=
 =?us-ascii?Q?p1QRjLCspsE2IwOutpLe/eclB4GADN05wOpNlEDzRlWLayeyS20nIffW7nAw?=
 =?us-ascii?Q?+mVi1YrBR9p/hRc6TRDRa+IR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b5b1d2-6d69-401d-b35d-08d8eee6fbd8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:10.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/x3UYRU0Wjt+QbqfvuVsYM77MEyscha0maO0WepxefaRYdW/eKgZtIV4CbthsY8aCFNBB5jRE++DjSnePcfMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hyperviso or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93dc4f232964..074605408970 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -216,8 +216,12 @@ enum x86_intercept_stage;
 #define PFERR_RSVD_BIT 3
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
@@ -227,6 +231,10 @@ enum x86_intercept_stage;
 #define PFERR_PK_MASK (1U << PFERR_PK_BIT)
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_RMP_MASK (1ULL << PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK (1ULL << PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK (1ULL << PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK (1ULL << PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.17.1

