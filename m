Return-Path: <kvm+bounces-17434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DCA8C68EA
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 16:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBE001F223CB
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 14:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42B6155758;
	Wed, 15 May 2024 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="jOrnupYe"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2125.outbound.protection.outlook.com [40.107.135.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0144E1553B7
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715783894; cv=fail; b=WKtn36aN49ON1tcltIaQpGWsxvpJ4NDyPlncFBz2FGy8Cl+qKHI9QhDKxnpKZHcPb/cL6DjNLDwEueGfcdK9nzeA4E+KTSaDuHD/Gr0GAUic8KJNvvOUp9fSJLh3lduQn6mxc5307jwkUikSpTzaBK6DA2VrsKf3HMr6D2hW6sI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715783894; c=relaxed/simple;
	bh=N0PaghPiPcVQbKO6Em5lQ3+Dgxdax/rXt0x/LbuUGXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KnNeD5kCZ01HxWkycFUpsm3qLPWWYtS19JE+GZ0WUVWf09Y+4WY+sGYumusLszlZZItZFecMbXut/9LV9TpioKoSBYblIUj2vIcCE/E5TaiZ/bKWce+GhQa7vdYJYE+BOM50KzY4bPbd9gVOHyI6pY8R48YxKwTR4PpvtD4nV54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=jOrnupYe; arc=fail smtp.client-ip=40.107.135.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWgRBzTk+Q7naYhseA1Ge5UJDcaoKdYCAo84xCG2fD+8YANVT1GVrH4xnUbC4j6SJO004d6kz1MyRzMqkXmTGdr2QL4yWM4Xlz1enS5rlcxGXo5+uz+4KHXU6fIz6pSD9Yxkg/Tyg3z4Wjon7JURf5kbLMC+Rey6KObj2DwNr7NrSiX9QZjWS5oaadzAYiUD77+WeI3U4n1dB0g/nM51Nnlvn8t8R/Gc3OrDsmjRBkEvNvzVHK8Hu2+TLfpRvt14gf4gNWsUwIT0UVESUbNRnDMVAKdNhSm2kH81ZMR2IEXnYhY7LOYhKJyZW5YSGxBJbkBQ+bH1xImyH3mpHclypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jffTmnRV0eWhKNMeCwBktxQDMHoVBXY86MQIBKWUigw=;
 b=dg+nVGXhlbXKFPl4iM8mhwn1euduiPcxQFLYfgJV4a4gGsM0kRxXV4GM10VmiJx1f38rWc4XtJrtsQGB0QHl+nwLRrNNnnOu4Z0wwNeqeNR58ugrbJCXiVZovNralZ03dFsJop6SLGTD7kRpAdLH2rnUwmUStL3T8iP5xE6/71spTR5PuVSlKXCrXKU51rcK3MJGFHpsORsckeFhXuFvYA+eW4dxenZMRN1DEMXGCbBt3KUvMYVjgcb8XpLdbwOwdBV6NOfI56xjSlhsUtY0yxynRIRBJkf7GiDyoGOFedpDrboxuwFlCKaRhhRX8JqghghuutBXzR2I1oPdPj0m0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jffTmnRV0eWhKNMeCwBktxQDMHoVBXY86MQIBKWUigw=;
 b=jOrnupYejm3SsvtAcrHn3fTiHNUMaKLCu7d3UB3ih+ygxSmHfLlvYfUhN8HnaEQZaWDxs3e8IGIK5wJqCyiTbt/Y2PSupOJkUctQCRjo6LMCqUs8g8kTlpagOMCDfQctkCAALcMKxCXn8E+2g11Co+AVHkicnc5Eo5Ag2VyubtaeSW/OCEwmlVPTSGppMee2EMFbktMIS6gGSzIwYl+iEpSWGK6ipZC1ZKc3Ct+VikSkLES+JvyEmkGcnwB5/68c643+3XhYOoU2VpDRGPbWM0zjN4VjygCrXEWxgNbNv+BZrxf6pdSKQY6yamDDeeyxc7KriYzpspIZrdflx5mP5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR6P281MB3849.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:10d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.27; Wed, 15 May 2024 14:38:08 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423%5]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 14:38:08 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: pbonzini@redhat.com
Cc: Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	kvm@vger.kernel.org,
	liangchen.linux@gmail.com,
	seanjc@google.com,
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com,
	thomas.prescher@cyberus-technology.de
Subject: Re: [PATCH] KVM: x86: Prevent L0 VMM from modifying L2 VM registers via ioctl
Date: Wed, 15 May 2024 16:37:26 +0200
Message-ID: <20240515143728.121855-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <82c8c53b-56e8-45af-902a-a6b908e5a8b3@redhat.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA3P292CA0013.ESPP292.PROD.OUTLOOK.COM
 (2603:10a6:250:2c::6) To FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:38::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR2P281MB2329:EE_|FR6P281MB3849:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b568839-7e55-4e3f-461d-08dc74eca391
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|366007|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WAJyEjecEFbB5wRrkKxVv4wvajXDbwJlSO7Y5hkcY4fDyUlsomdYyad7SCEP?=
 =?us-ascii?Q?eOwfOl4+YgcCHJ7zSBBgG8cVRpcol2s7OQici0u9kopedy5Mokrj6oYlnIV8?=
 =?us-ascii?Q?7VmkAZkUQPjgPBJvMAotDB+hMSnVFCsmtsAdgZtoirvb9JCpqn9VoqIHapyG?=
 =?us-ascii?Q?xZyuDg3HrS0gMrhkB9A1WODd9GgBVDw/CyCc6gI9g+K/KRPALfyO1IStbIvg?=
 =?us-ascii?Q?gpGlLAHAyU8hN1UECrDQQMFLtJQls0BzzNoog9FqInG83t3NLJz8307LhEe/?=
 =?us-ascii?Q?2p0hHr3R4g7e2HHJFykBNp/uKRJ7UQvfQL6BlAj52HSVb+p0mUBdno+utuR3?=
 =?us-ascii?Q?GgvG5Rh8ghpkhdeGwDhUlzl6Pa8vs6nDR/Avx0IcCieuf01wIJV6vm2JXDpi?=
 =?us-ascii?Q?IIZfXkerTvTtaqMHolujJfGfykJIy6fzBcFjAZinzhImvJ5sZctvCVzV4NHi?=
 =?us-ascii?Q?LW6+bI6N/K53xQ/5zlpwDiQmjhuZgEjzBhY6B5uf7JCybdhmtlGiD5UW4A3o?=
 =?us-ascii?Q?2si371/jrhqcpAIYBiVsrYo1GZCdPAIKkzVclS9l9VGoe/SgNSvRLLAsu7E/?=
 =?us-ascii?Q?wkt56RmPf4EMe31M2CtZeYxrpjV8z1luSj/16EqivRVQ/+fCvSKhqnXHvjP8?=
 =?us-ascii?Q?nbNk+JLEkLAOhZD8sDV6TOrFSjptYuZFzsFZAfVdgiyW4B1ynW3/Obk6JUBj?=
 =?us-ascii?Q?7rE7kxMS2D/bnRlEKuLdOoVa2V4OHlMube8xhGaD0b6hJ3tzyxP+AZ5eGkaS?=
 =?us-ascii?Q?0+loLiLfyZv0LYUH7kxeZXxyf5hhv03KscfV0bxIMun3JFkI0nMfmMyo35B/?=
 =?us-ascii?Q?DGenakCJe+5bSpart0HX1/SsYOaNXROHKIHsJNQ8rSg8J/Jgm7Ty0IuE++1K?=
 =?us-ascii?Q?fj5hP4nJTlQ4WOGdfHwZrT/Mq5D8vxG3swMxca0YC14AQF9LQBE/Am59Sv8y?=
 =?us-ascii?Q?/+0EpS3fEZY5LmoxKwKa+J+0nZbQ9krf89LwSwUfM7U2MckWrMwwyB5Byhtr?=
 =?us-ascii?Q?ookX02OIrOj4u5JvAuA++wNP+9O9EAdG3LfFiUmBn/i9ToxcSy0WU2R4aKqy?=
 =?us-ascii?Q?ovCEEm9mjEhEDDTatIZ9RDUy44W5sl0oy/Qb/r19eU9AJZ07M582+v/VYiCl?=
 =?us-ascii?Q?TvCrMa2ptHShWmen0UvdeI/S6J0aTYwM/WWZJhXlHpWcfjNBDxJiCETOaWU5?=
 =?us-ascii?Q?ds5dZKe8oAK+1zMpH1UJ488W3jWL7nUgoy1EMsxQU4uM9BjWphwSVUVDY8XF?=
 =?us-ascii?Q?axiQXj+iCD0CujKITVONUbZjS6BMsRidoG50iICcAw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RzERnKkQ9stxSB/snHgSBdMUh9LIFDpFiNQ2N3SquNUYB+OaDrDU3DzY8m0Q?=
 =?us-ascii?Q?8PSUTJpGT87PKARNwMMr6h2MPVNVCV+/2fp4Bsg3wEw1/Z6OkfG6SUyLf/w2?=
 =?us-ascii?Q?4pVyndYeyvS6edazx5MOJLNaNOE+PHRAhPpn+20UkxFJciwJgdyz5gIi+wja?=
 =?us-ascii?Q?OISELds/fewMX/+EZb6s4NaASXTa8mRGzH6CSosqxhA6pc+tL11Ddz4PWStE?=
 =?us-ascii?Q?GRVcXfKB7HyEAUYKo+oGHGareTuZePEXQG/87Fa11MFa/J+clycXOl840uIU?=
 =?us-ascii?Q?pMf+7OCIAseGHGX95sI+bBQwchDsCNqGOSnrulvXWAIeaqGCUDnaX8QOUWeH?=
 =?us-ascii?Q?ZwcbiNUbEuQ0LsneQpbgpBp+/bTvdXgGmhXbwaML4wNat1LHOW8pKImSXsoa?=
 =?us-ascii?Q?nc2xz56INlgi3OX7nHPJwVm26mp6825RIPZfH2xB6Fugj71dLvubVNxjvpPZ?=
 =?us-ascii?Q?doQ2Fc9/9Hk4YNZDOCXGM66bkdCtt5NmwsFL6aHjmdEu+S6UHn7/70QAxuQu?=
 =?us-ascii?Q?eEmF9lhHvvB5Mjvl10SvojQnboOZhD4DRgoNr65eMto11Il+rqQZ3JhyF6qz?=
 =?us-ascii?Q?jTcq3EuDQtIO59GI6JsL0DFQlv09jJk1P98P6z0qTG432EM4NnAzYi8bcFBM?=
 =?us-ascii?Q?ljPXCAodkOpiBFWy58mI0ucU36JYfttyfAvBCm97A7KOLLr7AvCzJVx+HR6Y?=
 =?us-ascii?Q?5175duoC9EHJsis4HsF9j3yvkdpnFtHF6uT0U1ynqlz2fC45bkwhb74q6DzW?=
 =?us-ascii?Q?ub2XAhG8NwWcNaQH5FtNtQc3q0i11j07LQJaC02acmUEtn5cvCQj3ALEM86m?=
 =?us-ascii?Q?wwXY8BcikSQWKUEsKKTUXs9jzz/o3ITqB/pLT1uLongpKDtLgLLgLCYy+TFM?=
 =?us-ascii?Q?Q+B96XX+TKJM/RmctSLd+AFOHzXbWXW+z8mJR9HpZKpk1kzEAwAWMtYw374+?=
 =?us-ascii?Q?QmHnUDrhFZkO29qrbN1exHcGdWPpgWadONi5zMwbBjm1+QwE1gZk4L7Z2jMC?=
 =?us-ascii?Q?lSL/V36XQk5XqTGfwAUBTs1BVFUj6aSB2cTVZ/gjnKpaGsOD0XHGkMd04OEm?=
 =?us-ascii?Q?qLxS7P9suAzLYzrKRi+3noASSYPY9J8t89H3fk8/QdhtRoivy9hK1d4+wq7Q?=
 =?us-ascii?Q?1yk6U4zxJe7XTayjWXo8fTM41sxUB9rA9+7LAcHcO+WR/yt5/eTfoDg6R70S?=
 =?us-ascii?Q?ucaUND6mzwHVdbsm2V0GbRpLMWqFx/pVlc8lOUSv9tQVdpzoj0Ld0H08wLaQ?=
 =?us-ascii?Q?iuGEnbfhuFo8uhJAoFUCbdcunxIBGRUoeeCz3WVSY7IHyjC8MPITtwDBGlE5?=
 =?us-ascii?Q?/03NGftAZIjbUb8WiNCLu86lKqYL31ZUojYJTHZwnXlH20jmwJI7KfIW5jVl?=
 =?us-ascii?Q?kKo6kvdhMSIlMDLqEMcQygZ6KIT7hwHvp31NMFq/aHYF1Kb4gqZifU9T6WaQ?=
 =?us-ascii?Q?sHXYjUeZ/vCgCCqsN7xWzH9LpLVSzZyFqcjHwfAZbFXTKLXEeaq9X1fbb5L0?=
 =?us-ascii?Q?fyQWAzH58to9GSt5l00wFiYYj6BfXH1LmFw3PXYtxu9TAOY7+GJXBj1LVXUL?=
 =?us-ascii?Q?MsA7OUM+TmWGj41pGYscTB7+pvAAPtGx16LbTtlBxGWkFaKOLhEjgSWDicpC?=
 =?us-ascii?Q?p+Bcw2MEkDcw8M5RyAA9peA=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b568839-7e55-4e3f-461d-08dc74eca391
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 14:38:08.9004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmHgtEnWnWVU6Gcwj5Tqy0MHAcylTDKo3p2T+edbu6kaFWRKXYiW4cgoiiFwjVF3dmctAxorlzLXR/8NpeiDPrKrlAZznGF2NvMrJTpYawB2z97UcYbjX8bLbXuoXAqz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR6P281MB3849

On Wed, 15 May 2024 13:08:39 +0200 Paolo wrote:
> On 5/15/24 10:06, Liang Chen wrote:
>> In a nested VM environment, a vCPU can run either an L1 or L2 VM. If the
>> L0 VMM tries to configure L1 VM registers via the KVM_SET_REGS ioctl while
>> the vCPU is running an L2 VM, it may inadvertently modify the L2 VM's
>> registers, corrupting the L2 VM. To avoid this error, registers should be
>> treated as read-only when the vCPU is actively running an L2 VM.
>
> No, this is intentional.  The L0 hypervisor has full control on the CPU
> registers, no matter if the VM is in guest mode or not.

We have a very similar issue and we already discussed it in these two
threads [1, 2]. Our proposed solution is to introduce a flag in
kvm_run to make userspace aware of exits with L2 state.

Julian


[1] https://lore.kernel.org/kvm/20240416123558.212040-1-julian.stecklina@cyberus-technology.de/T/#m2eebd2ab30a86622aea3732112150851ac0768fe
[2] https://lore.kernel.org/kvm/20240508132502.184428-1-julian.stecklina@cyberus-technology.de/T/#u


