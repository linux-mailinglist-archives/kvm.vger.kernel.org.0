Return-Path: <kvm+bounces-3996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F1880B9CA
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 09:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFFBA280EE0
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 08:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697E36D3F;
	Sun, 10 Dec 2023 08:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="OZ8aMSRP"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2150.outbound.protection.outlook.com [40.92.62.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3369D;
	Sun, 10 Dec 2023 00:08:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivq+NRXjxGDwnKnLRZGXu/whyyqDohuGgc9DHRz/N+8kdS2qwgRx6tXeYiUZsCP4CspfnSLaytb2crBkUMURY84KRfHktzBUlyKtRp2axx7moGbpr/I2+AYNceeMpEw17O7qzSkn+JETGbJHVCcs+Hg6OfAnUIMGYAyYQ09zpQeJtigxpjf/Rc/Fuxxbg90ckylqyMxUsdotknmvOsFJBhH0MdLj/dFlfj8r/fqv8gjqf92aL3GBh7IQgYA3rRa4PW7Gf+BGQdhBFYUoZmzgQahTeN0+Pc10IDGKCikp/uiYsfO735bN0MhhsuJHv4XB5WjQPpUIJBI7GFdAtIKxBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzAcBBC3/Qh5JHV4M83f1kBaLFDSVNfSmRZxxUCxyog=;
 b=efli0bupdNhVgqjnwi18WmWOk8a5DPWcd1w1edMLvYh0Ujm2yxD5juHOK30nk0OJRRMvxmNPtfxXggYFbV0r6QrhsD6vMHO0wQs58Us8EE+K2t41B1LPBQxr9ok6T1QRYtbs3wzsJoNDjQde4QgA2xnm5HY6yMwaHDYGf9KGqQJfF/B64TQ0m8St6VA+lFToi3KwhJNiyZfzqwARMC3uMq1TXi9t7FIkXNKEjOHRpKQa5sym1blKtFciyHO7TXhwD4YsEDAiYegaM5eZWXOyRoqvrYX1Qc/YwajyuDUafv/NTWjc0xX+UBYmDC3ONBU4AdmHoqEV3ZDeZHJO0L2btw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzAcBBC3/Qh5JHV4M83f1kBaLFDSVNfSmRZxxUCxyog=;
 b=OZ8aMSRPVUpn99S1lKPRGQWg7meUP76wavfBqFXDlh381lzEeFAA4hgb1JlOj46LcyizVdNsJp7o1qz+BECP7P7qMFPWNhD+/S3OMTAw8R8ff+PNIf1NsawHs5/22gssjQ5JB21vvdnsgTxXPSwS/N5oqNd4mBprA5hxDLZKgMoi1WVDPrlqxMJmw78mUyMzl7gRJB+cHpk+hz9DGWsQDxLF3dr4fPOHbQzeuMO/4zt8T+SJVXjuCrbPfjaM8rRTePfYfd5A56Js8mb3qwknKxT9x08We0j/R1xMpgKRHKKU1NUKLAEWBFOFHjTMwiJs/1z9jm77b4q+e4wF8Igw5g==
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
 by MEYPR01MB7339.ausprd01.prod.outlook.com (2603:10c6:220:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.31; Sun, 10 Dec
 2023 08:08:49 +0000
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb]) by SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb%5]) with mapi id 15.20.7068.030; Sun, 10 Dec 2023
 08:08:49 +0000
From: Tianyi Liu <i.pear@outlook.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	mark.rutland@arm.com,
	mlevitsk@redhat.com,
	maz@kernel.org,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	namhyung@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v3 0/5] perf: KVM: Enable callchains for guests
Date: Sun, 10 Dec 2023 16:07:42 +0800
Message-ID:
 <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [5hP5SFsKOSJHZzIDoL6ixfHLgGiQ2S0WroETPYou9oYzvUMOQ2+dyQ==]
X-ClientProxiedBy: SG2PR01CA0189.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::15) To SYBPR01MB6870.ausprd01.prod.outlook.com
 (2603:10c6:10:13d::10)
X-Microsoft-Original-Message-ID: <20231210080742.2135-1-i.pear@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB6870:EE_|MEYPR01MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: bfc982f2-5ffa-4a9b-075e-08dbf9573bf5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z1xFtd/ebhKIquqP+AniVhqEOR5bQv6zvqqrZrQEiWkLDkudW76b3dS0SsnxRSN4Hd8/rd9kqY3hrraBts6vKj04KqNo1hYV8pt49wRx9UJ2Yyxd0xnh+PZP/VSwsJvaPxcUt9UcmNssbrvBX8VfNAqu3LuV1udXL0lel3fYGlYedfgqj8GCUZE8haVvHkUPyY/h4By/Mxyy49T4TH5tscrKw6IH5tryo+aO+ebXHm3Dd4oU6//THlfmYcKbDdvnizO4YspBPoDff2v1X5X0sR8yDay3cIRpBHv+u2ULBpCHc9iCd0IXGF1F8mK8fd9HB7f7/P25onZ6kRybCEogoJE5NeEkkZUEqeNqW9jUIltjaAQomi7ajZxBSM6jg5knxDvLny2g74B/27EtP8cFV1l3s6pPv726B7K8qGeRPxh9sGYX+EJJSKw495/jFBvR3mXBQCA37E+OCcWJs/nAyXyigOtBUjuHPl0iBNxXrVAKb3qKMqu/31aoEu+qK+v1yV57RwdyHkWA1BSDKknRdU778lKQcKE1ji+G9XWB7wvXlZyo9wpd9Onobeq+7qefUHSd/NnU2vFdw/bOpQSAV5xzO609drhfzhpPXuXI69Y2poSVMwjYAG9UPwbHB7LqhM71CxsjCQ0W8DHiswNFHWL9Em+N/nsAdOA95dg0aa8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qtlAwsuqlHla7xOFiLSX6LBYfVNyLYKnfieGED40ASZkLRpm48NqaEvy1Gzn?=
 =?us-ascii?Q?KEYDZIxEIp6aLSVglZEZSz/9ABY5AvYy8ymwGnVX48RFAROpPf7skfDBLEk9?=
 =?us-ascii?Q?pAnd4hUs2StSdZT5oBFEygDXOiZJrDNFsB2h6jfbxGBPbi92RPz41gtAGP2R?=
 =?us-ascii?Q?tuu/NSkGEEeHnIFHUNvs8YLZdPgJyCAbFwGWT+7oNinI2i9Q7p29jJ9q7WHA?=
 =?us-ascii?Q?D99DqUzTPsuyK93ZQpFjjE9m8UAng/aiZkaBf8E+KRnH8oMrsUc4j2iWDzYA?=
 =?us-ascii?Q?hxSk7E7ktnEBhuM6ZGZpa7J7xgkEgCK+TdCxSEpMW0KjEfk+ZBW8Ji2/yDu9?=
 =?us-ascii?Q?uv8xLMDzXhQkk3EFeuksT9H5jdKzaAtwzsiFSSLDxfEj/7nqVsLauRdF4mK7?=
 =?us-ascii?Q?HOqNwrh0Z95Lz3FQlqnU42Jq4HU1hmA7HFJnzQK8yFyV/1dYAx/HZNPFEjCp?=
 =?us-ascii?Q?wkX/cgIzfDqbaNeLAOqIJb/jluldTsi3kdc7TZ+zpPpZhuMU2tUhv2kkKS3w?=
 =?us-ascii?Q?mPROzsOv1YMFmtHXThsJESAI7RY8L3PRooXB8Ou0t57OSN3NVmqT2Hnfog8e?=
 =?us-ascii?Q?Zbo/vivWQci28E0XrdgkN08wE1iG6eoXw5P5aCtR/fZ6QK6JUdGtr855GTJl?=
 =?us-ascii?Q?ypoE4E/rzeL3S3hqfYZUIor72gka/MZX7ZXIgQCO/XsrFsiH45iuhUNblnVP?=
 =?us-ascii?Q?ynTxRipAPY24Gd3p4oVy7TXWU3dsjF+hJfcGHRzeYlvz8YrpKTn03ckQj5T0?=
 =?us-ascii?Q?ZING7SVnvvLLps0Ev2mF26fbjggEN77COpzpJUF8NYwmu/TDvh8/qDBFfw+o?=
 =?us-ascii?Q?yIklzw48/pcz8vhdxOrAKvNsqf6U+5uDwhHv4f3YsUCBFDoIoovB3AhQpbrT?=
 =?us-ascii?Q?HQQ2bbpKV2mNIrPlokdenJY2owPzxSObNz+xR1vgPuKeeHI0ErQgQR0fPt5p?=
 =?us-ascii?Q?NB3AbBVkWk7IaplOlTy1/XOLJ1pPRiyLJ5MQBHtIfop/TvoXlB90FYKzjgDL?=
 =?us-ascii?Q?QpM3ebECAkJZuXPzCGMzGdrTDoCk4JEY30IqZqwyozUtp41+tyMyWLrcM0SK?=
 =?us-ascii?Q?+ZNIqdWfIsPtK1fQV0LU9MwG5YjaMWGgPrzm8tzCLx9VWXs+a2f5sewXGKsl?=
 =?us-ascii?Q?qVtlsRsTsIo09W2kRsYSz2sBsfwfQ0xd7JV+q+oo8guvIW4P32EoXpV3w8WY?=
 =?us-ascii?Q?FyLx7qZK9JDMdPO52Rpy6s+dCbwH7mA29J+IbV/T8+Ew4Hidw2jvPCBLIICB?=
 =?us-ascii?Q?7/gIWUfqxvcum83cbRLz?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfc982f2-5ffa-4a9b-075e-08dbf9573bf5
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB6870.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 08:08:48.8734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB7339

This series of patches enables callchains for guests (used by `perf kvm`),
which holds the top spot on the perf wiki TODO list [1]. This allows users
to perform guest OS callchain or performance analysis from external
using PMU events. This is also useful for guests like unikernels that
lack performance event subsystems.

The event processing flow is as follows (shown as backtrace):
@0 kvm_arch_vcpu_get_unwind_info / kvm_arch_vcpu_read_virt (per arch impl)
@1 kvm_guest_get_unwind_info / kvm_guest_read_virt
   <callback function pointers in `struct perf_guest_info_callbacks`>
@2 perf_guest_get_unwind_info / perf_guest_read_virt
@3 perf_callchain_guest
@4 get_perf_callchain
@5 perf_callchain

Between @0 and @1 is the interface between KVM and the arch-specific
impl, while between @1 and @2 is the interface between Perf and KVM.
The 1st patch implements @0. The 2nd patch extends interfaces between @1
and @2, while the 3rd patch implements @1. The 4th patch implements @3
and modifies @4 @5. The last patch is for userspace tools.

Since arm64 hasn't provided some foundational infrastructure (interface
for reading from a virtual address of guest), the arm64 implementation
is stubbed for now because it's a bit complex, and will be implemented
later.

For safety, guests are designed to be read-only in this feature,
and we will never inject page faults into the guests, ensuring that the
guests are not interfered by profiling. In extremely rare cases, if the
guest is modifying the page table, there is a possibility of reading
incorrect data. Additionally, if certain programs running in the guest OS
do not support frame pointers, it may also result in some erroneous data.
These erroneous data will eventually appear as `[unknown]` entries in the
report. It is sufficient as long as most of the records are correct for
profiling.

Regarding the necessity of implementing in the kernel:
Indeed, we could implement this in userspace and access the guest vm
through the KVM APIs, to interrupt the guest and perform unwinding.
However, this approach will introduce higher latency, and the overhead of
syscalls could limit the sampling frequency. Moreover, it appears that
user space can only interrupt the VCPU at a certain frequency, without
fully leveraging the richness of the PMU's performance events. On the
other hand, if we incorporate the logic into kernel, `perf kvm` can bind
to various PMU events and achieve faster performance in PMU interrupts.

Tested with both Linux and unikernels as guests, the `perf script` command
could correctly show the callchains.
FlameGraphs could also be generated with this series of patches and [2].

[1] https://perf.wiki.kernel.org/index.php/Todo
[2] https://github.com/brendangregg/FlameGraph

v1:
https://lore.kernel.org/kvm/SYYP282MB108686A73C0F896D90D246569DE5A@SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM/

Changes since v1:
Post the complete implementation, also updated some code based on
Sean's feedback.

v2:
https://lore.kernel.org/kvm/SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM/

Changes since v2:
Refactored interface, packaged the info required by unwinding into
a struct; Resolved some type mismatches; Provided more explanations
based on the feedback from v2; more tests were performed.

Tianyi Liu (5):
  KVM: Add arch specific interfaces for sampling guest callchains
  perf kvm: Introduce guest interfaces for sampling callchains
  KVM: implement new perf callback interfaces
  perf kvm: Support sampling guest callchains
  perf tools: Support PERF_CONTEXT_GUEST_* flags

 MAINTAINERS                         |  1 +
 arch/arm64/kvm/arm.c                | 12 ++++++
 arch/x86/events/core.c              | 63 ++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c                  | 24 +++++++++++
 include/linux/kvm_host.h            |  5 +++
 include/linux/perf_event.h          | 20 ++++++++-
 include/linux/perf_kvm.h            | 18 +++++++++
 kernel/bpf/stackmap.c               |  8 ++--
 kernel/events/callchain.c           | 27 ++++++++++++-
 kernel/events/core.c                | 17 +++++++-
 tools/perf/builtin-timechart.c      |  6 +++
 tools/perf/util/data-convert-json.c |  6 +++
 tools/perf/util/machine.c           |  6 +++
 virt/kvm/kvm_main.c                 | 22 ++++++++++
 14 files changed, 218 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/perf_kvm.h


base-commit: 33cc938e65a98f1d29d0a18403dbbee050dcad9a
-- 
2.34.1


