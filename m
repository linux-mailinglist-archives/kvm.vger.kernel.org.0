Return-Path: <kvm+bounces-68490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 00583D3A3EC
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 11:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 081203032711
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5953563ED;
	Mon, 19 Jan 2026 09:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="JdQovgUk"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012061.outbound.protection.outlook.com [52.103.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E9C355804
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 09:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768816774; cv=fail; b=stMBAX78AD7reYeo75+C4cG2kmnShTsIX9fBhzkcOj/2cPsiqW/RR6kNmRtfpSVv98wVbpq0Sm5oWOSQkqvQShcn4snd4Xlx06B2FQL4S274SWE5KH2ZRg+8M9G0bRXA3ytgJ+dQIXQUxev3hgxYp45Ik0uuxIas4jfAnoSkGZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768816774; c=relaxed/simple;
	bh=XanIsviNjW+V6ffY6EruLQqRi08WrGo9E0facF7+108=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QsoER12TMYdW7g9yBnvysmaMLil//sG8slZ0sjgu6V1FQVnGQb84g0Q2F6KwdRBeaehJVIvzo0uobHc3tt9cXTWrnWVWaqScmimM/dZUBKdJikpejCSNZPmRdggRLYuOVfv1qZQCcgAB3fxKT0YoAuFNMP3viclmBjexgs/wXCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=JdQovgUk; arc=fail smtp.client-ip=52.103.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2AYgkTNpsnjoPT8VIOuds5oX5esHSdjMswJphOjliD4r4nC8j6hML/2Cg5KFbMpE7FfHbxOEW7TMaGiGmeqZqgRw2DXSfBdsGx+Y2V7cuxFMV4mDq0hAHGvpdbvIJm4MHLNQNy1PacGAq3uE1YUSIovp9dIAhBmez2zl8UEXMoTLkqWzvyLZcN9cmPeBeL0mz8dq6MwCw7xQN0G7uWN1ZgmwD4acZ+PrwFY9GSDaOAryaIckABnIDZDdjRZeEFksu1WvvlsiGkV7YsD5hSzLPBNytkHHIflGVuYKqBy1y1eR2VgkPF6GK1iPupn6CKiROtYyaFyIWX2LtZBWZbDtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjgPFSANrCxsg8UjhsgikPONTB7QTZSLoUZfhVjT5o4=;
 b=nnalXiN2x7x9g/UWmmEkz8Z9x6wHpFeqp7hgNub1k8XhsfX6Fow3tvTz5EkhaO48wVLXCpV0FMaoCP/RPTBzzyDy5uWXly93cZld3NTWqnzH3qvt7DYga12k0mFZRel0PE4FuX27NMJgC1JdtTt+8dQ5DZYGEzX3pBOHJ9TkdRXbmcsTwM6xfkPz9IzN9yriOVM+LzheO8olVwwow/fEqcNDi7XkanjT+dnYlitAK81S3bfPs3pk07xZRdpojlWHU9/BKAI0mI/jlAg26Gv7/2FDAbBtDgIl+yC7W0V2wpBiIdOzgMXojVHCJHpAv6wu7sCIVB+JJRtpBxmHcS74Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjgPFSANrCxsg8UjhsgikPONTB7QTZSLoUZfhVjT5o4=;
 b=JdQovgUkpMd7osQ3mGeT1E7u7BdPfAefd9/cyY+Z3RV89H0rQDXy6b0kO/kFfKQ/LH8dq95PGGUaGntilb107g2HfxIxF07BbuCbNxcLhotxACaACwvOEeC7icIz546AWYKc0NTMfY8CFLuXZdAdfXZxaZVqtk/A1yKJwGqWL1t8pOnTkaGppgGmBhmkJxj72XfX8pgyFkl4UefleWoBrwd1dbXAUqvmU9LNY+rXHNtxrVcpdH098hDBCr+Bu59yJaQiHruaNW9jag+ICqB552hjuucwnfC2SOZM/7TVkvZkit4Gt6ufvD5niQLTvHrKUdfRD72nUMf0xjM/qKo8Rg==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by SEYPR04MB6896.apcprd04.prod.outlook.com (2603:1096:101:dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 09:59:26 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 09:59:26 +0000
Message-ID:
 <KUZPR04MB92655B1C5641B953F0F3D433F388A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Mon, 19 Jan 2026 17:59:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: riscv: Fix Spectre-v1 in APLIC interrupt handling
To: Lukas Gerlach <lukas.gerlach@cispa.de>, anup@brainfault.org,
 atish.patra@linux.dev
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, daniel.weber@cispa.de,
 marton.bognar@kuleuven.be, jo.vanbulck@kuleuven.be, michael.schwarz@cispa.de
References: <20260116095731.24555-1-lukas.gerlach@cispa.de>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260116095731.24555-1-lukas.gerlach@cispa.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP301CA0066.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7d::7) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <b6b27ef6-e295-49e6-b1ef-47cdb6e973af@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|SEYPR04MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 16f1ae78-0e27-49a3-9389-08de57416de8
X-MS-Exchange-SLBlob-MailProps:
	7J/vb0KDx3hVaBXFi3Zmt48msziUWKBFh5NPeuj9bn1S0zzitbWRlJdnuouuo2vCUdiwEnUGSP+oLMsryvh8EyUfJ5suSLP4S0sKGlxbkKy6cl/XWcc1OhwJYK16ebDmt0Pd1etOZBT2u+tX6qOLV1gtn0yk1kx/lZfLb8Hkzzdfnl4zcMcsGDcbyuuyNltU34mojffyC+dzzwGSy990RkfepLILmdIMZXrb4pYhvKJBUCsBIFlblaKZk8HtBEpkiua8zzu3JAk867vWW/vypmkwHQy1/xJENQXmPvarCL1ejRAoOMyTYWzU4k1gLTNytDizBJTirAUhAQE7CDuA3sZ9llywuNGIMnGmCb4fzrvZm3iFdIGAcdMI0+doIfDttvgvcRbwmPqElNYqHRpeUuMO+oGrZvzTQj66uJk+xS/Z8HVmH/jsFBZGAnLeKEG1kYMtKqJ9gmZPv7CybUDg4aUb1ucUNC2Fz4zI2nh1Rx656Pt8yFU4ufSHeR6s0Gg1qz4sjl7BkcxOGKBa34U5tue9FKYvJ8X2sRnKNU59KJUsXr8wWGCsm+9rOdB03qj8fjjhXy26ZM7SPk8fJ3Vt7ZTIDdn9AKQqr+vOsgofnT3oTCrFxKGsjFJvzP4fgVjo4exflvPJLOsjC/9nIs8NE2JJrfIFZNNIH0N5Jee6RUiLoN89ejKI3BhxNMRHcKtTPbg4SVGYkBZsc9XlnS6If8g/M+vJ9A+uBu/uhHvLBZ6BoLTUTTI+d/uewD22MUDZuvXdC/OLHoQvRnDBy0KrhNQw9/2IwzP0+oJkXbuIi6E=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|15080799012|8060799015|41001999006|19110799012|6090799003|5072599009|461199028|7042599007|23021999003|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnNsVWZMSVBKMUZIK2E3a0hmNDJIUEs1eUZHRmRRVUFSMXNZT3V3SFdCZDRr?=
 =?utf-8?B?RlRLbmZHWUdjcWVldEVTa254Y21wTDZSOXJ2V2tDWGpJZEIxblJ5dDlzenRD?=
 =?utf-8?B?VXZnWGRyU3VpeEZ0bUdUUHVDaGQrUjBndGpZSVp5ZWl3b0twcHowbkF5U0ZO?=
 =?utf-8?B?NWUzQ3d1N2R6WEdhcENidU8zdlNvWlJhVEpmVVVwdkJPWDl4S2hrRExNQ2Ur?=
 =?utf-8?B?emRkKzR1bUZFSzdtamdGWG4reHFwYVBwTCs5ek55VDRMaDFPQmpxUU1CY0Vl?=
 =?utf-8?B?bkVtcUVISXp1Yy9vdXNhQUs5bktLRzMrb3AzeXgvTis0SkxBbk1YSHdQWEtv?=
 =?utf-8?B?NFpoM0tidlNLVkhOc2dORnNhbVdjeXQwTU5Id1BONjhkclFSZmVqRlpHcC9X?=
 =?utf-8?B?endlUWRIbXF6SU9ncWROM29GeEs3UzhuTkJ1TFErUXVMSHlnQmt2TWpaSC9j?=
 =?utf-8?B?c0JOWGJTcmlzajAxd0J5REhwcUNSTDk4RGMrMjkyOVlDVWJHclNxSEZPc2Fw?=
 =?utf-8?B?czVmWEN6MExDTTlpZU9adnFXejNWdk1QeXNyS0N3VUJLS1ZCK1hxL0hsRmpr?=
 =?utf-8?B?OXNTenpqaUZZeGt6VFZzNGsrZDE2SWJpcHh3cW5MYjdrbWgxNlJDUVdQWm16?=
 =?utf-8?B?NEM4RGs1YUJxYlFQWEIxallEMFBOZWErd1U2TVpab1FKUXVQcTN0aERrMUFi?=
 =?utf-8?B?QlB5ZmRRbFBZcDhJU1ErL3NFelVmV3p6NkNTenNoVnNlWnVnUXBKUVV3emMx?=
 =?utf-8?B?c0tIYmlMSXZ4dDg3UVVneS9XcWZ2MThkZDFHWjJyWGEwMURHcEtpMFFPV1pE?=
 =?utf-8?B?UWpidFRMN1FGRFdFOW8yRE1EdXROVCtXdHBHZlZRNjR0VjdFcHYyN2I2N2Vn?=
 =?utf-8?B?M2ErN1lYZXRab082L2dDQnBNck5wT0VQRUpWSzBBSUcyTmY2MUtSejBXY2tP?=
 =?utf-8?B?a2k1eGtrQndUaWZieG1UblhQb0p6TmdxeW4wcGpiczNQWUdSdkJXOXBTK3Zi?=
 =?utf-8?B?bjNVZ3JuNEo3TEo2ZFBBMmNFazNIV1Z4dkNnSXI4WUtORHVWTkRLMmZNNHN1?=
 =?utf-8?B?c3diVjE2YTFhZUQ0WnJFd241b2dJVDlJNG5peXQwM2JhWE9kRzBxQlRnVFAy?=
 =?utf-8?B?R0psbHF6ODNGWHg1TElrSzVvMzVkcFNCamkwR2lpZ3NFNG1zRGYra2xwVzdr?=
 =?utf-8?B?eVNXVGhmam9KT0FsK2tHK05jcXRpeFNXWW8zL28yRHNPejVIcTZ6YlBtblRB?=
 =?utf-8?B?RDVrZ09XWUFiU0hXMlQrbUdRQnptWFJMVTJQTFhNalRBbjdDWVdQdGZQT0Z6?=
 =?utf-8?B?S2J0NlVjK2gzQzFVRmlDVXhmZ2RsakxOSmVjN0ZDZzVCRk8vV0NJbW10OXpy?=
 =?utf-8?B?VDMxTkw3Si9qZ2xsNDE5b1NTdFFBczBkdWhRRy9DNE1wdnhYYkRpU3A1WC9n?=
 =?utf-8?B?bFBBQm94MGFsbm94cUdJTW1CSVNSaENSYmI1eWJsRFgvU1hOdkNpaHpOc09R?=
 =?utf-8?B?SHU3NTBsb053OXloOEttcHRPalZnOXlRWjUvclJ5cmlzNW5MTnEwSTRrMzFS?=
 =?utf-8?B?a0hTdVprOGlvc0U5NGlQZktsS2s2Q3ZjbnVkTXJaSXNqY0tBSnYzZUJ0VU4x?=
 =?utf-8?B?QXl2SkIyZ0t5VmF2Q2xBY1JaUlcwLzZoZGZCNlJONU9YYnZOZTNJSVF6cEpi?=
 =?utf-8?B?cmdJenpUWXEwNjVBdXhoTmJiUVBjNzZUYldGZ3V5bm1VNTRISEhlaGhRPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OExPcG80c0NtTlQxLzVyZmFYdnN3bndDYkpaMU5WZDFNM2U5a01GT2EyWE1m?=
 =?utf-8?B?SDJud0tyM1R0eUk2VkhLWDl6eXhhdURrRmI3dmVaY2ZYOGhMM0l1bnZteUpQ?=
 =?utf-8?B?WG5NR1lOVC9LdkZ5eFlpK0ZuOWxrODNieXZBanVoMmVSUzRXMUZRQ3A3dXVD?=
 =?utf-8?B?cElRNm5YaXpma3ZVS0JnK2pjd2VheStNSUxNdkhMaCs5UWpHQkN3RHZsMVpH?=
 =?utf-8?B?V2I4T2RZMFVFc1BFTS8vdndnbjlmZEVLMnBrV0hEZDhQUzlGS1J0TmdtRkVv?=
 =?utf-8?B?M3Nlbjl5NXJGTnFjcGxlT2JrL3QrUndEUkpNLzh5Ni9FU1QwTml2dXZVa3Bx?=
 =?utf-8?B?d0JCS2RhQlQ5bzhVQ0tOdUtqeEJ0NlJQSGRjZzlzWGFkdURRbU13SFQzRyto?=
 =?utf-8?B?NFM1U1E4aEVXTzhlN1c5NEpMMzVUK1p0M0dZaDRyN1Y1MVRLdldQUFNRWHlr?=
 =?utf-8?B?eERRUWd1amhLV0tDNzYwMVF2RFBUY2VnY2tveTBlYlhKTFREandsU3ZmKzRI?=
 =?utf-8?B?SHptZXhDck5CWnZ6R3A3Q25yRGJBMEEzNzNIMlZ6NHpxOGdLZjUwQXgvQk1M?=
 =?utf-8?B?QTM0MlFzdy80WUpmZ1UzK1RyZnJQanpEdExOUHlOamlNeDdvSUNrbnU5TDlx?=
 =?utf-8?B?YXFsaWpYc1lwY2pzbUt0U1Z5SUFBUUJMamc3ZlZmaGtuZUptZFNmR2VXZlk3?=
 =?utf-8?B?aXcxV1FVYzJlOXhXdHFHRTl3b3FJUlZGRHdhdk1FWWhpUUR2Z2RYTjd4Rk0v?=
 =?utf-8?B?Q1ZkSlZqN0RzaWg4VC9wc0ZZdHQxTzZBbXdESWh0eWIzbHhMRG0rZk43WHVM?=
 =?utf-8?B?U2F3SVh6d2JzSk5EYmVmSWtuTCs0T3VZdHh2VjlpeithcndybU9MdzFrT2t5?=
 =?utf-8?B?RTlJWTl5V3NxbWpPTDNhQWhvajBPM2toZlM3YjZtZm5kQmJVN1A4VHhkalJz?=
 =?utf-8?B?M25paGw2QWczZHhFVkZsaXA3a05pRHVmcU1LN2NGTmNQdzlWeW16bmpUS3NS?=
 =?utf-8?B?THJJMGlPZjlabm9ObVh5Y1F4OCttcGE5MjJDOXU3OFNVdzQ1RWYwdWd4U0N3?=
 =?utf-8?B?aVdyTkg4OVQ5TXhBZzBQTW05R0tpZU1HeEhoaUdFeGVRdEdkU2hpS1JaZ08x?=
 =?utf-8?B?VG0xU0VBYmU0aHY4RlVsa1RrYXZIanNISkRua3dWbndDem1PSWdIT0JUYXVx?=
 =?utf-8?B?bjlKcU1pSGNRVTVyS3h2WEdwM044SFpCRVBoeUd2MnhsekRQYStFd241K1Nw?=
 =?utf-8?B?Vkk5aXM3NncveENsUnlIKzlwRnZjL0txUjJOQ1RoZHBFRCt4MTdlbEVnZE82?=
 =?utf-8?B?cHVtOWNUalR2d0tVT1J2Vk0xdS9BYnpHWmwvRi9Mb1FXM3prdzl6dTF6NEU1?=
 =?utf-8?B?cXpWWXpUVktxZ0ZHVGNtY1ZpYXVrdkY4Z1NPeXVFb05DZzMwc2hseG5veHM3?=
 =?utf-8?B?ZnR3aFp0b09LZW0rS1VIdXhjaWZ2NlVoc0Jva05YOHJlTDZ2cXlvQWdyNjJi?=
 =?utf-8?B?SmNOM3FKTG9Ka0RoNmtVWnhQNUdIbzZIRzkxMERDUXNwM0c1Wm1TVm8yUGpy?=
 =?utf-8?B?MXVvTVZoaXpDU0ZTRXo0L0FuVWtHcjh6bm4xcmd3NnZSbm9VeGl6SEF4RXY0?=
 =?utf-8?B?WXhCclNpek5DZ2NTRzdVQW56TE5sTEo0RFcvOEt2cTdPMnJEczVxcXhDTkFU?=
 =?utf-8?B?VEhwaDJJaHlmSExYNXhsTU5TTW00d1Y0WFZkWWpHNmdobEVidmhaYnJ5dHNO?=
 =?utf-8?B?SDYrSWQ1eHlzemYzU1E3aHlNQkJoOEU2eVJNT0p1dnc0V2N4Q1VCamIzZ3RN?=
 =?utf-8?B?Wnoxcm5zbHBPa2VoZDhhbmZ2dkhCTlllWjI1Z3E3WE1sMEp1dDNVNGtMbjNi?=
 =?utf-8?Q?HzCXg+KUyKvL4?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-515b2.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f1ae78-0e27-49a3-9389-08de57416de8
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 09:59:26.6871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB6896

On 1/16/2026 5:57 PM, Lukas Gerlach wrote:
> Guests can control IRQ indices via MMIO. Sanitize them with
> array_index_nospec() to prevent speculative out-of-bounds access
> to the aplic->irqs[] array.
>
> Similar to arm64 commit 41b87599c743 ("KVM: arm/arm64: vgic: fix possible
> spectre-v1 in vgic_get_irq()") and x86 commit 8c86405f606c ("KVM: x86:
> Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks").
>
> Fixes: 74967aa208e2 ("RISC-V: KVM: Add in-kernel emulation of AIA APLIC")
> Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
> ---
>   arch/riscv/kvm/aia_aplic.c | 23 ++++++++++++-----------
>   1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> index f59d1c0c8c43..a2b831e57ecd 100644
> --- a/arch/riscv/kvm/aia_aplic.c
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -10,6 +10,7 @@
>   #include <linux/irqchip/riscv-aplic.h>
>   #include <linux/kvm_host.h>
>   #include <linux/math.h>
> +#include <linux/nospec.h>
>   #include <linux/spinlock.h>
>   #include <linux/swab.h>
>   #include <kvm/iodev.h>
> @@ -45,7 +46,7 @@ static u32 aplic_read_sourcecfg(struct aplic *aplic, u32 irq)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return 0;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>   	ret = irqd->sourcecfg;
> @@ -61,7 +62,7 @@ static void aplic_write_sourcecfg(struct aplic *aplic, u32 irq, u32 val)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	if (val & APLIC_SOURCECFG_D)
>   		val = 0;
> @@ -81,7 +82,7 @@ static u32 aplic_read_target(struct aplic *aplic, u32 irq)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return 0;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>   	ret = irqd->target;
> @@ -97,7 +98,7 @@ static void aplic_write_target(struct aplic *aplic, u32 irq, u32 val)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	val &= APLIC_TARGET_EIID_MASK |
>   	       (APLIC_TARGET_HART_IDX_MASK << APLIC_TARGET_HART_IDX_SHIFT) |
> @@ -116,7 +117,7 @@ static bool aplic_read_pending(struct aplic *aplic, u32 irq)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return false;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>   	ret = (irqd->state & APLIC_IRQ_STATE_PENDING) ? true : false;
> @@ -132,7 +133,7 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>
> @@ -170,7 +171,7 @@ static bool aplic_read_enabled(struct aplic *aplic, u32 irq)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return false;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>   	ret = (irqd->state & APLIC_IRQ_STATE_ENABLED) ? true : false;
> @@ -186,7 +187,7 @@ static void aplic_write_enabled(struct aplic *aplic, u32 irq, bool enabled)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>   	if (enabled)
> @@ -205,7 +206,7 @@ static bool aplic_read_input(struct aplic *aplic, u32 irq)
>
>   	if (!irq || aplic->nr_irqs <= irq)
>   		return false;
> -	irqd = &aplic->irqs[irq];
> +	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
>
> @@ -254,7 +255,7 @@ static void aplic_update_irq_range(struct kvm *kvm, u32 first, u32 last)
>   	for (irq = first; irq <= last; irq++) {
>   		if (!irq || aplic->nr_irqs <= irq)
>   			continue;
Seems the above code would be better as follows ?
                             if (!irq)
continue;
                             if(aplic->nr_irqs <= irq)
                                     return;

Otherwise,
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> -		irqd = &aplic->irqs[irq];
> +		irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>   		raw_spin_lock_irqsave(&irqd->lock, flags);
>
> @@ -283,7 +284,7 @@ int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level)
>
>   	if (!aplic || !source || (aplic->nr_irqs <= source))
>   		return -ENODEV;
> -	irqd = &aplic->irqs[source];
> +	irqd = &aplic->irqs[array_index_nospec(source, aplic->nr_irqs)];
>   	ie = (aplic->domaincfg & APLIC_DOMAINCFG_IE) ? true : false;
>
>   	raw_spin_lock_irqsave(&irqd->lock, flags);
> --
> 2.51.0
>
>

