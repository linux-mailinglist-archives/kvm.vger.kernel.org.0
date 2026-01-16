Return-Path: <kvm+bounces-68308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48081D31780
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6DE53025A64
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7272422D7B6;
	Fri, 16 Jan 2026 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BbuD4rFO"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2608922A7F1
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768568386; cv=fail; b=AYgM7vsg2A10CuyclKKpttlO73K8P/yvCz/qk63x1r31ToIw2CVHP4vHMT1uXsNcAcDwmU1rEEP6FEd/ylMNKTVz4EFfxZZLn+iJkhEqfX4P0XrwX7Y3J3Kxjx3hgM1fDb7jlcVPZ5GvwrhpaVegxNQm1FM3uAqHmVmLMvTXv18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768568386; c=relaxed/simple;
	bh=RCv0J8oquHNj2s3LhFKKyEtLcoLXMMx09DtJurd7Kes=;
	h=MIME-Version:Content-Type:Date:Message-ID:CC:Subject:From:To:
	 References:In-Reply-To; b=idgZ2eyHxm3liF7depJJOi1yfo0yChrAMcoFgjgAukVBD+6izTSC6PhBBZDsbv7cYMdCV/azayMp1j3q+EcOh0yvg5+Vsvwtu1Q6NqCE+4Sn/TNRSC/1liEW5b5sr9eHvoANQm7NtDKNtqRQXo03nRzfmqzbhRoUOfFmw+I+5Lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BbuD4rFO; arc=fail smtp.client-ip=40.107.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i3227nm7lsrOWRjHFTKhijzMLdEE0FKroueiE4J+REv0SovAy8yAEgNASs5+sPrf7AmxfZ7kY5KnrknICwzvrmF8CWT2eKpD+o/nVZK7z1v7tYLYdJmcCdX0oNT5DN84eyoXlzhdH45a5uSj3TSHtU7BE+M089nCakQ8pPuFXB48baP/Y0h10S/NMUvuEqFChzOjrtRQct4Tdzq3b4uQ+KYLj8+sMe1nwWd6RE6bAmCCEYC263pe3uy8dbybN06B78BWR7uVmHcvqOJOEwat4MIKBKXeeQFkF56G7/jRSozGuNXaGCM6735PsFPf8PZCbVYON57pK53PdiCYgCPpVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEhWkesXbfXe/9EQE9RtTtFPS49ayRIP7Z0K+3qqMDg=;
 b=fvc1b71RmZ4GWoRODv0Q8AbMPoGwwEqmDSXhelfg27pv1KhKBrm5a+iSecTOPuetNAefe07RVBwF0a/QTf34ZWGJlQomfsucLMO+YM/PBtya5Dwk6pZ+vzbxyE9Gw0QX08BQMsaqh67WpSNQBJVkhnxxRSsgS1yybapz+xaWgShD3lzpa3V2NkCoEUcSuDP3ABSKCpDFtTgsci3CUtnIhxUFI//qdD2rghV08o2eFxfZUqb2Hpcfe9aQ853BAL+36avC7vXPtw5HNvcb33VGRfbFB1DVNnYbcs073pdkzN6QkASsLu5LnnZIBbUI6P2smGLbYzg5F/y+p8l9fONXOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEhWkesXbfXe/9EQE9RtTtFPS49ayRIP7Z0K+3qqMDg=;
 b=BbuD4rFOgwcgLjWQMGzi4gSXvP0IBbo8kJ633CAHj3bmFx0XDlFhh3pzn6LCBL/s/x3fxn22/rCYav4EHFVFD9lZ0NLNt7EMHilo92rhFqdmDkqGl9s8HLBUPHjhm3mFpDGhp8g/U3MA9D3s8ee2eaES9wNaeIuVkZX/3QPvOJc=
Received: from BY3PR10CA0020.namprd10.prod.outlook.com (2603:10b6:a03:255::25)
 by DM6PR12MB4089.namprd12.prod.outlook.com (2603:10b6:5:213::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.7; Fri, 16 Jan
 2026 12:59:40 +0000
Received: from SJ1PEPF0000231D.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::b0) by BY3PR10CA0020.outlook.office365.com
 (2603:10b6:a03:255::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.9 via Frontend Transport; Fri,
 16 Jan 2026 12:59:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF0000231D.mail.protection.outlook.com (10.167.242.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 12:59:40 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 16 Jan
 2026 06:59:39 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2026 13:59:37 +0100
Message-ID: <DFQ160CKADCU.1FURW65OWRT1E@amd.com>
CC: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Yosry Ahmed"
	<yosry.ahmed@linux.dev>, Kevin Cheng <chengkev@google.com>
Subject: Re: [kvm-unit-tests] x86: Add #PF test case for the SVM
 DecodeAssists feature
From: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.20.1
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
 <20260115164342.27736-1-alejandro.garciavallejo@amd.com>
 <aWky0xn4sG2dNryK@google.com>
In-Reply-To: <aWky0xn4sG2dNryK@google.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231D:EE_|DM6PR12MB4089:EE_
X-MS-Office365-Filtering-Correlation-Id: 1309d4a9-d1c1-4f2e-dd5f-08de54ff1c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RE5Ld0VFRWVZRDBYbkNTUU43VVY4ZGJJdk9mTXlDa2xyYXdTaWZYT1VNZTZw?=
 =?utf-8?B?MkV0L3pQWjNOUGRXamlWZ2NGYXZwNGlVUm5BMHp2SlpHWS9PWFNRemlqU3J0?=
 =?utf-8?B?WjNqOGQxOUhwVVFRYUk2RFJzOHhrREp1ZGE3ekN2d0pSZk9xV1RaSy9NdGs4?=
 =?utf-8?B?cnR4Qm1MSnZ3V0dzSlVxTThPMk1KWlpTSFRTcEZEQmpsRkVhRUFPVi9VM01k?=
 =?utf-8?B?SW9GUlo1WWhwSmloK0w1dGdjLzhwZHRBYUQ5Tk41OTVRNjVjNFh2SlBMbkFx?=
 =?utf-8?B?OGU5QXBndStIZkFTa0pWL3lhdzJmMC9mNmZwaEZZbE9mejk2NFZDeVFpMWxY?=
 =?utf-8?B?aWRKY2E1SzlTNW1CRW4xWlg1MkxxdnlBYUtvbmloZ3lqaHg2dmNodVhpbWNj?=
 =?utf-8?B?NzBWSEsycmhhRkhzTTRicmhqS0dsZEpTallHd0xpQlFwVS9TMndQY0R1Z0gz?=
 =?utf-8?B?NGxHOEIxWDJGL1VwY2dMOTMyMGZlMFhkV2dGWUhEK0YwRE5uT08yU2pwT2xa?=
 =?utf-8?B?NWVLbWg5Q3lIS2FjOEgyWHBNSnFWSEtOZ0pGQXM5NGIwenkrK1dNR3NjdlBF?=
 =?utf-8?B?QlJhbFpFWEk5UG5LdVhZOW9WVDNsdVg1QVAzdHVTVWQ0K3diR3gxWkNkcjcr?=
 =?utf-8?B?endRWEhMNTdqOGdOeE1BSzZlUmtUREpBRkxlc0RhL1o2NzR3NXNlbWtJdHRL?=
 =?utf-8?B?UGtXNTJnZDhWd1BCMTZXbEw1MEEzT2F4a1UrYVFEaS8wVmZuV3NwT1RJVW5z?=
 =?utf-8?B?VzVTeFQxMS9TT2l3NU44WjFsMXUrL3NvcXNhWU81MHMvS0d0NHl3dldTdXlq?=
 =?utf-8?B?VWszdHp0cHNMby80a0JlOWR1YlVJZHAyeENUS2taV3NBd0M4UzdWRmZRaFJy?=
 =?utf-8?B?SUJocWdUeTFIQ2RuRmZQZ2lYSUlTWDNCeTNmamNaUDNMdUZWcWNYZVZ0Uys1?=
 =?utf-8?B?UVZjRXR4R1YzeEdGMEtScG1UeTRCUldDTW5rMU5tdXNmb25mZnVHVU5nZmdv?=
 =?utf-8?B?bFY5KzhSQVV1SWdiOGhSaUlEVVplQ0E4M2RmMkhFemdOaDFYRHNpemlxcU40?=
 =?utf-8?B?MDBLcnI3d0tPL3JMVHBqc0syQ3huYzc4MDlmRm1HLzF3aStaUGF2V3pscVRl?=
 =?utf-8?B?SnE1ck1tTzJHdU9uNEhneGNacklKenoyTVJ3dm5KZG9KWmtzQzhBWDBxUktw?=
 =?utf-8?B?WE95V1FHNlAvRnlTUk1rWkQzYUg3T2RqYmd3U3RxMU1yOVBtR1pRbmVtSkpa?=
 =?utf-8?B?UHY5UStSWEJlbHZhSFBlNmI2b1M4RFpMTmZkOEEraUliK1RNRHAwTWp0aExO?=
 =?utf-8?B?TDVFZGxsZHNyczJFYjc2cWIvb204WVZPby9RZ2FOV21zQjYvNEdnNUd4T0Y4?=
 =?utf-8?B?ZzhYdEdYa3FzVGlvc3FIRnBOWUtyS2ZaL3ZjclhNSWttcWlGbFR0YWhDNjI3?=
 =?utf-8?B?dUVDT1ExQjhjZnBjNWEwWXllM0ZtOFgweXViQmVaYklrM1ZzUzJUWXJUZ1VH?=
 =?utf-8?B?RDhWRzBGTVd3QUFKUFlFcUJzclZuRU1WTHpJTko4dkFERDhKZjlLVUJLN2Z3?=
 =?utf-8?B?aWo3UjJsYkhKb09TZ2FFUFFBaXdUVDFITXY2ZXM1QXk3SlV6dXAvcE1QR3VO?=
 =?utf-8?B?WFBKZGFleVB5dnYvV1MxWWpha0JXVmxRYkRXdnlXd0o1ZDA4cFJVQ2xFcmhW?=
 =?utf-8?B?MU5CVkJDK00rQXVMSk0xZnduaUhiUGR0N3FWZXVXUERUSGtsM3ZQWThYS2JT?=
 =?utf-8?B?dnVtT0tXalFxVjRiWHRrZlpCRjZ3RFNLNWFZNjVOWk4vZFNmUUFXd3RSMmVP?=
 =?utf-8?B?TW4rTHdISU9zYWxDZnEvTG82Q3NjdFJES2tCUWVzMTlhSFF3Wnp0bjhXbTQy?=
 =?utf-8?B?T2NGRTNvUWVEc2xpMG1vWmgrUkhkNDNlcVhQY3M3YnI4eE0xV2k2c3pPbERH?=
 =?utf-8?B?Vmw5Z0xkTGZReVMyallJUWFTd0dTTTJxY2lNcEV5ZDBHRk96Y0NtS1M2NmRt?=
 =?utf-8?B?bm1WcXplUXE5eU1QV2F0Slk3bmh3cmtxRG1yZ09YclJ5N3c1cncvc0VuaVdN?=
 =?utf-8?B?ekdoVGZBM3FhSGlwcTliSFdWY1hoU1JnMWVQYSthZGZNeksxRmlnSS9kYkx5?=
 =?utf-8?B?NnEySjlra0d6RnZZRGZ2ak42aFcrS0YxTnJaTVljSy96QllZblV3RS8zaHlw?=
 =?utf-8?B?VHZSZmNRNGtmZEp3cXpIeFJjSlZEMVNReitiM09GL3BtQ0x6TDVNczNoa0l5?=
 =?utf-8?B?UTBqVEplOXI1OVRCdXVGQWdrTGlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 12:59:40.3710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1309d4a9-d1c1-4f2e-dd5f-08de54ff1c84
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4089

Hi,

On Thu Jan 15, 2026 at 7:32 PM CET, Sean Christopherson wrote:
> +Kevin and Yosry, who are working on similar tests
>
> On Thu, Jan 15, 2026, Alejandro Vallejo wrote:
>> Tests an intercepted #PF accesing the last (unmapped) qword of the
>> virtual address space. The assist ought provides a prefetched
>> code stream starting at the offending instruction.
>>=20
>> This is little more than a smoke test. There's more cases not covered.
>> Namely, CR/DR MOVs, INTn, INVLPG, nested PFs, and fault-on-fetch.
>>=20
>> Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
>> ---
>> I'm not a big fan of using a literal -8ULL as "unbacked va", but I'm not
>> sure how to instruct the harness to give me a hole.
>
> Allocate a page, then use install_pte() or install_page_prot() to create =
a mapping
> that will #PF.

Right. It hadn't clicked for me exactly how L1 and L2 are related in the
harness. So this test group runs with the L2 reusing the mappings from the =
L1?

>
>> Likewise, some cases remain
>> untested, with the interesting one (fault-on-fetch) requiring some cumbe=
rsome
>> setup (put the codestream in the 14 bytes leading to a non-present NPT p=
age.
>
> Not _that_ cumbersome though.  Allocate a page, install_page_prot() with =
NX,
> copy/write an instruction to the page, jump/call into the page.
>
> run_in_user_ex() makes it even easier to do that at CPL3.

I didn't mean fetch as in faulted instruction, but rather the CPU hitting a
missing PT as it fetches the 15 bytes of the codestream including and follo=
wing
the faulting instruction. That'd be...

  opcode_pre:
  mov ($not_present), %al /* #PF! */
  not_present: /* page boundary */
  int3; /* unmapped in the NPT */

... where the CPU would try to fetch int3, and a bunch more bytes on VMEXIT=
 but
fail, thus leaving insn_len as "not_present - opcode_pre" rather than 15. I=
n the
absence of faults the CPU always fetches as much as possible on #PF/NPT-fau=
lt
intercepts.

A complete testcase would show the expected non-15 number as length.

>
> All the above said, I would rather piggyback the access test and not rein=
vent the
> wheel.  E.g. wrap ac_test_run() a la vmx_pf_exception_test(), then interc=
ept #PF
> to verify the instruction information is filled as expected.  We'd need t=
o modify
> ac_test_do_access() to record what instruction it expected to fault, but =
that
> shouldn't be _too_ hard, and it might even force us to improve the inscru=
table
> asm blob.

I can see how this would be better for the simple test I have in this patch=
, but
it would probably overcomplicate ac_test_do_access() in the more complete
version with the instruction being at the boundary of a missing page.

I'll try to integrate it anyway on the off chance any other caller happens =
to
need it. I'm skeptical the result would look pretty, but we'll see; maybe i=
t
turns out alright. I'll get back to you after I find some time to play with=
 it.

On another note, would you prefer individual tests for every single assist
or does it sound ok to have this single test for the #PF case? There's no
meaningful difference between #PF and NPT faults as far as the assists are
concerned, and all others are implicitly covered by virtue of exit_info_1
being unconditionally copied irrespective of exit code.

They are trivial to write, so it's simply a matter of the test volume you'r=
e
willing to have.

Cheers for the feedback,
Alejandro

