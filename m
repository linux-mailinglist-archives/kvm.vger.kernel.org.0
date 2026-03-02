Return-Path: <kvm+bounces-72386-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JMLHYappWmpDgAAu9opvQ
	(envelope-from <kvm+bounces-72386-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:15:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C89A01DB9BC
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:15:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAEEE309EEAD
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BC2407598;
	Mon,  2 Mar 2026 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qp3tSD/o"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B052AD03;
	Mon,  2 Mar 2026 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464108; cv=fail; b=lG7DFJR9/lGYZu6f8q9Z/MSWiY4QWCpMnaUvET9W89As+6sRxHUomheHTo97/XYcLZ8w+frtp02PDUVwHH3c+TyDWc74JBzRGwbFboW5lMFA95YdhcQa52pxhTonOq2pkTDLzz1EoWfcAhwAIXT3mmVl3QaZPyFiF6FfJ5eRsvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464108; c=relaxed/simple;
	bh=uJv2nRlNbMwJlNXzditzcZKupBRA77CX4hKnyZyYiZ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A2HC3NAyUbEMfdZZSgD0kuYKmyl8RXr6+SHxHRfAp6gp6TjK36aydpXTzuwi6HALRuFeUeNpQjEK8Ii/TKPmeJZPSf4bD80tPIOU3vhp72rYSnYGrMqEMQc1P5iCU5B5kREKZvwXGAnqqnrhMyxZ/cNE5UR5pJsTZ8HbyoJ29hY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qp3tSD/o; arc=fail smtp.client-ip=52.101.43.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvHdc51i+pMlIU/pf6mbDMzjknCCeGZywZkPd6XmjRsE5dm9QhzRkfoBhsTTtt+MvvqIodb0wBqduDSgEQh0M7/pEZfUJPJO9q6yYkcE3NqVGo8Rq/9aFwwvHnO2BzWHBYlwd6b/xOxYu44Ofg1OtG3zZ517fDeyA0D3Q2ozL3qrDVr/E4GqpS21RlvzIGsj0mZU3dXuFjq9ALo1na5118ny4nlilllNG6kAIDJ1YxI8hBOlnAj72jfb9DMOJ4uko2yXny2mmZiK5nLnIBC5RBnUjhaidnLKqSNHjtAQrMryANgWhKb1wxBVWekl6uhdzf7bJ6yUKIyZ7zpGn80K7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5A3FoX8pIkM5Gc7azeQcqBlr8gqHxVkl0p8fzGbHvk=;
 b=awR3cqpoZfwBMAU2pc8IWov7euQCM18e5gDhSBa7Ve/fi+if6lZXpCXQnK2IRGOICB8OZxANoSPQbmdokbAxa9quGKYeFJE6zuJxYg2TYqFvtpJMjJyp8Yzh2Di601fyxfFDOWxE7vTNFC2365E8WHjMLZdHaXCFjZ4uf8fYdZB7/ez/PZN37N640fK7oMj4CTgUZ/WdcuL4w48U9AQ5C/xcj93eknQM0zf1E3PwmHeK524Bf/R0+KHr2XcTZ0popBZEStf/trbBCVdCduJOj9GOC8BHrVyh9UBeGQSlWvboB06JBNjoKfr6UQ3MmjbdvC6oNPgtNT52YIgVfnd7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5A3FoX8pIkM5Gc7azeQcqBlr8gqHxVkl0p8fzGbHvk=;
 b=Qp3tSD/oPdd3C0PBRICzHE9iRZETTj/uMQAhfRh7hoyjmmNdG0/ic13dmH4i22zUPt02P41Cr/xQvuHiYOgp+0T8eArtPg+2ZNrUuXSWj00sIi2AjS7yNpXSTHtUZRe6p5Ikf0vv4G+Irnzd3HfGIOvYHqfdadNK4I/gyNANQcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB7962.namprd12.prod.outlook.com (2603:10b6:a03:4c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 15:08:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 15:08:22 +0000
Message-ID: <45f3b7ec-6796-43a1-90c0-baf2d9b7e383@amd.com>
Date: Mon, 2 Mar 2026 09:08:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260302143626.289792-1-thomas.courrege@thorondor.fr>
 <20260302143626.289792-2-thomas.courrege@thorondor.fr>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 xsFNBFaNZYkBEADxg5OW/ajpUG7zgnUQPsMqWPjeAxtu4YH3lCUjWWcbUgc2qDGAijsLTFv1
 kEbaJdblwYs28z3chM7QkfCGMSM29JWR1fSwPH18WyAA84YtxfPD8bfb1Exwo0CRw1RLRScn
 6aJhsZJFLKyVeaPO1eequEsFQurRhLyAfgaH9iazmOVZZmxsGiNRJkQv4YnM2rZYi+4vWnxN
 1ebHf4S1puN0xzQsULhG3rUyV2uIsqBFtlxZ8/r9MwOJ2mvyTXHzHdJBViOalZAUo7VFt3Fb
 aNkR5OR65eTL0ViQiRgFfPDBgkFCSlaxZvc7qSOcrhol160bK87qn0SbYLfplwiXZY/b/+ez
 0zBtIt+uhZJ38HnOLWdda/8kuLX3qhGL5aNz1AeqcE5TW4D8v9ndYeAXFhQI7kbOhr0ruUpA
 udREH98EmVJsADuq0RBcIEkojnme4wVDoFt1EG93YOnqMuif76YGEl3iv9tYcESEeLNruDN6
 LDbE8blkR3151tdg8IkgREJ+dK+q0p9UsGfdd+H7pni6Jjcxz8mjKCx6wAuzvArA0Ciq+Scg
 hfIgoiYQegZjh2vF2lCUzWWatXJoy7IzeAB5LDl/E9vz72cVD8CwQZoEx4PCsHslVpW6A/6U
 NRAz6ShU77jkoYoI4hoGC7qZcwy84mmJqRygFnb8dOjHI1KxqQARAQABzSZUb20gTGVuZGFj
 a3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPsLBmQQTAQoAQwIbIwcLCQgHAwIBBhUIAgkK
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAmkbaKgFCRZQah8ACgkQ
 3v+a5E8wTVPFyg//UYANiuHfxxJET8D6p/vIV0xYcf1SXCG78M+5amqcE/4cCIJWyAT3A1nP
 zwyQIaIjUlGsXQtNgC1uVteCnMNJCjVQm0nLlJ9IVtXxzRg0QKjuSdZxuL5jrIon4xW9hTJR
 94i2v3Fx5UWyP2TB6qZOcB0jgh0l01GHF9/DVJbmQlpvQB4Z1uNv09Q7En6EXi28TSv0Ffd1
 p8vKqxwz7CMeAeZpn5i7s1QE/mQtdkyAmhuGD12tNbWzFamrDD1Kq3Em4TIFko0+k5+oQAAf
 JFaZc1c0D4GtXwvv4y+ssI0eZuOBXapUHeNNVf3JGuF6ZPLNPAe5gMQrmsJinEArVYRQCuDA
 BZakbKw9YJpGhnSVeCl2zSHcVgXuDs4J2ONxdsGynYv5cjPb4XTYPaE1CZH7Vy1tqma8eErG
 rcCyP1seloaC1UQcp8UDAyEaBjh3EqvTvgl+SppHz3im0gPJgR9km95BA8iGx9zqDuceATBc
 +A007+XxdFIsifMGlus0DKPmNAJaLkEEUMedBBxH3bwQ+z8tmWHisCZQJpUeGkwttD1LK/xn
 KRnu8AQpSJBB2oKAX1VtLRn8zLQdGmshxvsLUkKdrNE6NddhhfULqufNBqul0rrHGDdKdTLr
 cK5o2dsf9WlC4dHU2PiXP7RCjs1E5Ke0ycShDbDY5Zeep/yhNWLOwU0EVo1liQEQAL7ybY01
 hvEg6pOh2G1Q+/ZWmyii8xhQ0sPjvEXWb5MWvIh7RxD9V5Zv144EtbIABtR0Tws7xDObe7bb
 r9nlSxZPur+JDsFmtywgkd778G0nDt3i7szqzcQPOcR03U7XPDTBJXDpNwVV+L8xvx5gsr2I
 bhiBQd9iX8kap5k3I6wfBSZm1ZgWGQb2mbiuqODPzfzNdKr/MCtxWEsWOAf/ClFcyr+c/Eh2
 +gXgC5Keh2ZIb/xO+1CrTC3Sg9l9Hs5DG3CplCbVKWmaL1y7mdCiSt2b/dXE0K1nJR9ZyRGO
 lfwZw1aFPHT+Ay5p6rZGzadvu7ypBoTwp62R1o456js7CyIg81O61ojiDXLUGxZN/BEYNDC9
 n9q1PyfMrD42LtvOP6ZRtBeSPEH5G/5pIt4FVit0Y4wTrpG7mjBM06kHd6V+pflB8GRxTq5M
 7mzLFjILUl9/BJjzYBzesspbeoT/G7e5JqbiLWXFYOeg6XJ/iOCMLdd9RL46JXYJsBZnjZD8
 Rn6KVO7pqs5J9K/nJDVyCdf8JnYD5Rq6OOmgP/zDnbSUSOZWrHQWQ8v3Ef665jpoXNq+Zyob
 pfbeihuWfBhprWUk0P/m+cnR2qeE4yXYl4qCcWAkRyGRu2zgIwXAOXCHTqy9TW10LGq1+04+
 LmJHwpAABSLtr7Jgh4erWXi9mFoRABEBAAHCwXwEGAEKACYCGwwWIQTdWKXnw4wULDeIG/Xe
 /5rkTzBNUwUCaRto5wUJFlBqXgAKCRDe/5rkTzBNUw4/EAClG106SeHXiJ+ka6aeHysDNVgZ
 8pUbB2f8dWI7kzD5AZ5kLENnsi1MzJRYBwtg/vVVorZh6tavUwcIvsao+TnV57gXAWr6sKIc
 xyipxRVEXmHts22I6vL1DirLAoOLAwWilkM+JzbVE3MMvC+cCVnMzzchrMYDTqn1mjCCwiIe
 u5oop+K/RgeHYPsraumyA9/kj8iazrLM+lORukCNM7+wlRClcY8TGX+VllANym9B6FMxsJ5z
 Q7JeeXIgyGlcBRME+m3g40HfIl+zM674gjv2Lk+KjS759KlX27mQfgnAPX4tnjLcmpSQJ77I
 Qg+Azi/Qloiw7L/WsmxEO5ureFgGIYDQQUeM1Qnk76K5Z3Nm8MLHtjw3Q7kXHrbYn7tfWh4B
 7w5Lwh6NoF88AGpUrosARVvIAd93oo0B9p40Or4c5Jao1qqsmmCCD0dl7WTJCboYTa2OWd99
 oxS7ujw2t1WMPD0cmriyeaFZnT5cjGbhkA+uQGuT0dMQJdLqW3HRwWxyiGU/jZUFjHGFmUrj
 qFAgP+x+ODm6/SYn0LE0VLbYuEGfyx5XcdNnSvww1NLUxSvuShcJMII0bSgP3+KJtFqrUx9z
 l+/NCGvn/wMy6NpYUpRSOmsqVv0N71LbtXnHRrJ42LzWiRW2I5IWsb1TfdMAyVToHPNaEb0i
 WiyqywZI5g==
In-Reply-To: <20260302143626.289792-2-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0113.namprd11.prod.outlook.com
 (2603:10b6:806:d1::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 447df6df-e439-4bd7-1168-08de786d8bb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	1349NkoIhZqFtkwPFE4ROFet4pPKyFBxYmqRbqop4r/g/xGL2xt36WcRe39ne9Sd44LQTPF1KqfpgPbZXewahw6U63yBSXM6qK/CwJ/93apC8cyttJZLRMtGqs8Kqi9lx8S6ocvATBeVbbcWZ8UlTsOCYvWOftAxsXiQEobV3V6YnNyaPUAJbqrpv3aAI/QfwSEdpOdubIH8T5Z85o51oRDthxrhskrCA24522nV6gXn0Jj7IEbMpvjmHj98Ns6VgawVVoyXdaN3BY63ZZtxrdJLn5AEMJOj4ou17So9w5tdefeubq12HvTjq1se1sy2DZgJUygYJnwbpWp251vcZZ1P4SF04Spyj7Klwtdte2PJW3Y7sjoUWn8UUG//j0MR3rnuuhq84DIomo8f+xKc4E52d8sgP7aLATLf0vSb91WqkRmlMmUx98Ze4TYQNYHr1gx6QwXhPnP8+q1ojwSo0zbVZUCY7D28g3NRC90+tzrIWFSHyh3tPEJ0eSV23ENdsGiDjbAcpkvD1KhHKAxiUzB/E66nHrZyyAkNrMOU94DtkJgkQzNdGnbsMShYZxi29wFKIApsFLw6xoLZ7ZaIQ1z2gkiTtVZhdV//gQZEdqZ1RRl9i7ixNIcGMqnYpRJYRn2pL5vSwrPHfy/hDRzoWsX8CgaVmD/s8jgi9GcvvaFKkHxvY2++XWH2/uaJVHddU0SCn+LVZYe+PWN5mwrWBr3MZzM5JKHNEVdBnvcqn6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEIzelZPM3ZYcjRHVWhHNXoxMWZwRTU4QVlObDJURjE0bGFsNUQwNTBtc3Mz?=
 =?utf-8?B?VVJiOUZXQTlWRmRYR0RwMUdDTE5hSUR2S1UxSkJhUWNuU1A3VlRISU1DN1Yz?=
 =?utf-8?B?UXJGTTlYV29zZGprOGdOMngwRGZQZ1pOY2d4RjNWckJlTVRFNTFMVnUvSHNs?=
 =?utf-8?B?akEzN3pjQ2xtdHJqUXFlY0w5WkEzbENZQTB1UVVEM3hZMHNQTktTdGtjMStr?=
 =?utf-8?B?V1RlTVdoT0VoRG5BMngrbE1OMEc5cnEwN1FNN1RnaVRSYlJFeXVRbzJWUlpj?=
 =?utf-8?B?MlRmZEdoTnJleXg5a1Fwb25jbWZWbW9TUkxkNEt0WThsVDRuMVNJVC9ROU13?=
 =?utf-8?B?U3RnWHRYSFhpUjdDUXg0dzFSRnNLZWk0NG5wTW4xYjEyaW43bW4wT3F6ME5a?=
 =?utf-8?B?M2pESkJORGV3TkVuVVhlZ3h4Yk9Xbit4a0Q5d05tRC9oWXVxOVk4VTFJQS9s?=
 =?utf-8?B?R0J6M1dZSDRZQ0h4aUpFNjJjNTE2NkM2UGV3WU5nWVovV1hjdVU5ckt1RHR5?=
 =?utf-8?B?OXpldnBjZnc0UGIzY0hQeERyL3h4REZ4OE5CVzRycW1uOVFsN2ptMEJKOE95?=
 =?utf-8?B?YTl5NjIwRitZbXBIR2pEVnB2cTlaaEZOMXdwa2tNVFF5VTlNSnZEVFZwRDFX?=
 =?utf-8?B?dVQyWjlVMm5tTm42emJPMjY0WHhMU0RlaVd2NXdrbVFJaWduZzlKVEY1T3d6?=
 =?utf-8?B?UVFML2xIVlNaK3F6QldyNXpYWGpDb2dDVUp2N1FhZGIwZTVMb1VBUFg0Rnd5?=
 =?utf-8?B?L2MrV1Bqb01qdWl4bTFvWklrdDBqV2J0dlc5ODVVN3ZDdHNtNUc0T1cvQUpJ?=
 =?utf-8?B?YVlUdUdWbnBsVlJvWWpWdzBYRWUrWm9ySkpXdjJRaGs0bVBtNi8vdzVkTnFq?=
 =?utf-8?B?VzFNbFBWWGJsRmRHaDlrRm1NbnNUL0NRYkticE8rSEEvN0pIQjg3U2VPeEtw?=
 =?utf-8?B?NWFaSE9TQVBXclFmc0lPZDIyOENxNmNQbmhldUlMMmlKbXZOMkZnbVBkREhw?=
 =?utf-8?B?SjNmNE95NnkvUm5QbEdhWGJNeFNtTG9WMGhUVU5EVDhnRllrTFBPa0RjUVpV?=
 =?utf-8?B?akZkZXhGcjZ6R0pJandHSDF1eitwS2pXT3RRcVJ0RGF6UUlPalhybHc0eWhW?=
 =?utf-8?B?c2NLSUFkL28yUHBxa2w0eWlSZGlQVXNuQmJxOFFpcCt4REtnUGI1WFYvVTd4?=
 =?utf-8?B?RERpNFc4THFGdndzRFFQSmgrWW1qWmlDYlY5Tzcva3Z5a0hSVUFKZnBPVW1Y?=
 =?utf-8?B?U0QzQjU4RmlWejNKL0lqclhJY2NzbmxDVGFDdWxndlI4QXg0MW40ck90dndF?=
 =?utf-8?B?NmNRSVg3b3J1NXVPYnRDT0huV1JxU1lqNko1TXVST2FxM0VVSTRRUGZJYUlv?=
 =?utf-8?B?R2ZoQ1RGQTF1eFdqZ09neTFLaWd0T3ZkM1dmRUV1aGFoWlNocXRlVWVPc3lt?=
 =?utf-8?B?S3Nrdlo4NUtQTThqNE9Fb1c3cG1ZL3NlQzRESjFFbWk2bkdENGNwQTR3WHdu?=
 =?utf-8?B?SkREckRwTFdMVFJmMEpSdmVGU3NlZFhxMmJnSTdEelBmbDJ3ZFdPWnBtNXE5?=
 =?utf-8?B?RERDNEl6VXJRbnI3c3NGTEkrdVdBWnpPZzgzUEhDK2pKZERqOTlEOXNKVmNB?=
 =?utf-8?B?UVlXV081T0ozV1JtK3JWSitUaVUrMjhIUC81azRzN0pBOU5oNVcvTXdoL3cz?=
 =?utf-8?B?b0RpOUhSK1hGUmN3NTRkVXY1K2psajMrTFhETGx4T1A5NDBnMWhNZ2t3TkJK?=
 =?utf-8?B?YUlGWTJpazFyZE9PWnV5cWhROU5LbUEzd2hoUkdyUmp6Z1FReDN5OUJwYzQ5?=
 =?utf-8?B?L1Z0UEV0RlNkaWpiVmJBWDYwQjBDL3M3QS95aHBPVUl1c3J1RDFCN3YzSzZV?=
 =?utf-8?B?Vmh0bzZPOVlyR0pTSHVuSys3RmFmVHlSVWpmY1JMYm9QVW5sS2hhL2lIOUpN?=
 =?utf-8?B?Mkg3YkNFUjkvZVM0MUxHM3R3cldjU2ZkeU0zM2xRVWs5bHlGYmdNZklIMzdz?=
 =?utf-8?B?TEVEWFQ0VlBwUWVwdEI3cWtoT04xWVBjaDM2Z0xXTEVJeVlPRTI4K3FNNzFR?=
 =?utf-8?B?eThqWUM5cDlZSUU1NmZXY2M1a0h5R014V2dHUTRnLytFTTY0V1grblZkeDdy?=
 =?utf-8?B?U2ZoN0NHUExzdElXMW1CVUw4TW9hbGpINkZaNlc3STBSNkMzUzlJVUJKc0ZL?=
 =?utf-8?B?UjhxUlZONnIxR3ZtN0pBNjd3TnFPS05KSTR3TjY5Q1lKWTM3WmpjUzk5RGJu?=
 =?utf-8?B?aTZrNWYyWWdCTGErWVBHdzg0NXdONlF1c1QzbEIrZkdqelNTUlBLMmZaZHRO?=
 =?utf-8?Q?tUZgDk1xBoaQlfcJT+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 447df6df-e439-4bd7-1168-08de786d8bb7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:08:22.5731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x67uRrFQa3pibGx9y6EQmC5NQ7YCX+SE7v+mh4cCJ4cNqyj+aprO6Y+ClXzpNZr+Kzs0ZdCY2uC9xZgpDU6e1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7962
X-Rspamd-Queue-Id: C89A01DB9BC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72386-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,thorondor.fr:email]
X-Rspamd-Action: no action

On 3/2/26 08:36, Thomas Courrege wrote:
> Add support for retrieving the SEV-SNP attestation report via the
> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
> ioctl for SNP guests.
> 
> Signed-off-by: Thomas Courrege <thomas.courrege@thorondor.fr>

You're missing my Reviewed-by: from the v6 series. Unless there were
some changes that need re-reviewing?

Thanks,
Tom

> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 27 ++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 +++++++++
>  5 files changed, 131 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index b2395dd4769d..38522b174a7b 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -618,6 +618,33 @@ approach to synchronizing firmware/certificate updates via file-locking,
>  which should make it easier to maintain interoperability across
>  tools/VMMs/vendors.
>  
> +22. KVM_SEV_SNP_HV_REPORT_REQ
> +-----------------------------
> +
> +The KVM_SEV_SNP_HV_REPORT_REQ command requests a hypervisor-generated
> +SNP guest attestation report. This report is produced by the SEV firmware
> +using the key selected by the caller.
> +
> +The ``key_sel`` field indicates which key the platform will use to sign the
> +report:
> +  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
> +  * ``1``: Sign with VCEK.
> +  * ``2``: Sign with VLEK.
> +  * Other values are reserved.
> +
> +Parameters (in): struct kvm_sev_snp_hv_report_req
> +
> +Returns:  0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_snp_hv_report_req {
> +                __u64 report_uaddr;
> +                __u64 report_len;
> +                __u8 key_sel;
> +                __u8 pad0[7];
> +                __u64 pad1[4];
> +        };
> +
>  Device attribute API
>  ====================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 846a63215ce1..d86cb352ea89 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -745,6 +745,7 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
>  	KVM_SEV_SNP_ENABLE_REQ_CERTS,
> +	KVM_SEV_SNP_HV_REPORT_REQ,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -873,6 +874,14 @@ struct kvm_sev_receive_update_data {
>  	__u32 pad2;
>  };
>  
> +struct kvm_sev_snp_hv_report_req {
> +	__u64 report_uaddr;
> +	__u64 report_len;
> +	__u8 key_sel;
> +	__u8 pad0[7];
> +	__u64 pad1[4];
> +};
> +
>  struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3f9c1aa39a0a..62daa23ccd1b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2271,6 +2271,66 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +	struct sev_data_snp_msg_report_rsp *report_rsp;
> +	struct kvm_sev_snp_hv_report_req params;
> +	struct sev_data_snp_hv_report_req data;
> +	size_t rsp_size = sizeof(*report_rsp);
> +	void __user *u_report;
> +	void __user *u_params;
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	u_params = u64_to_user_ptr(argp->data);
> +	if (copy_from_user(&params, u_params, sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.report_len < rsp_size)
> +		return -ENOSPC;
> +
> +	u_report = u64_to_user_ptr(params.report_uaddr);
> +	if (!u_report)
> +		return -EINVAL;
> +
> +	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!report_rsp)
> +		return -ENOMEM;
> +
> +	data.len = sizeof(data);
> +	data.key_sel = params.key_sel;
> +	data.gctx_addr = __psp_pa(sev->snp_context);
> +	data.hv_report_paddr = __psp_pa(report_rsp);
> +	data.rsvd = 0;
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
> +			    &argp->error);
> +	if (ret)
> +		goto e_free_rsp;
> +
> +	if (!report_rsp->status) {
> +		if (params.report_len < (rsp_size + report_rsp->report_size))
> +			ret = -ENOSPC;
> +		else
> +			rsp_size += report_rsp->report_size;
> +
> +		params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
> +	}
> +
> +	if (copy_to_user(u_report, report_rsp, rsp_size))
> +		ret = -EFAULT;
> +
> +	if (copy_to_user(u_params, &params, sizeof(params)))
> +		ret = -EFAULT;
> +
> +e_free_rsp:
> +	snp_free_firmware_page(report_rsp);
> +	return ret;
> +}
> +
>  struct sev_gmem_populate_args {
>  	__u8 type;
>  	int sev_fd;
> @@ -2678,6 +2738,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_HV_REPORT_REQ:
> +		r = sev_snp_hv_report_request(kvm, &sev_cmd);
> +		break;
>  	case KVM_SEV_SNP_ENABLE_REQ_CERTS:
>  		r = snp_enable_certs(kvm);
>  		break;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 096f993974d1..30d715f19a25 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -252,6 +252,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> +	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
>  	default:				return sev_tio_cmd_buffer_len(cmd);
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 69ffa4b4d1fa..c651a400d124 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -124,6 +124,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
>  	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
>  	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
> +	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
>  	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
>  	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
> @@ -594,6 +595,36 @@ struct sev_data_attestation_report {
>  	u32 len;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
> + *
> + * @len: length of the command buffer in bytes
> + * @key_sel: Selects which key to use for generating the signature.
> + * @gctx_addr: System physical address of guest context page
> + * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
> + */
> +struct sev_data_snp_hv_report_req {
> +	u32 len;		/* In */
> +	u32 key_sel	:2,	/* In */
> +	    rsvd	:30;
> +	u64 gctx_addr;		/* In */
> +	u64 hv_report_paddr;	/* In */
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_msg_export_rsp
> + *
> + * @status: Status : 0h: Success. 16h: Invalid parameters.
> + * @report_size: Size in bytes of the attestation report
> + * @report: attestation report
> + */
> +struct sev_data_snp_msg_report_rsp {
> +	u32 status;			/* Out */
> +	u32 report_size;		/* Out */
> +	u8 rsvd[24];
> +	u8 report[];
> +} __packed;
> +
>  /**
>   * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
>   *


