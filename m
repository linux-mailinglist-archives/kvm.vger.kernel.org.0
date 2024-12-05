Return-Path: <kvm+bounces-33173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 815579E5E26
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 19:18:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D65F9188576E
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052FC21C199;
	Thu,  5 Dec 2024 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="V/WjzeuK"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022135.outbound.protection.outlook.com [52.101.43.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69678226EEE
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733422706; cv=fail; b=iU1B4KXGKZigvNzKVUNTArHQqF55B7RaN/yB8um4UmgKYNjpJmx8YjecOq0uYVAKyFGplzyv+NcYj1L37jQZK/zJXa8EPHH++/X28m5+5t2n23PjoY3w7W3DgdXpVWL41+l903uOEeP027CwAleoX0LX/2dNPlS/bg9orKAnKBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733422706; c=relaxed/simple;
	bh=rhj6atGbkaljE3A4gBPVJkmLJTxnAMazhY2Wi98cYJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=huAAStBbAyXRJ3AHrBzFd/PPMnJkpVDZbguUZ524Uh1lipft98/qpGVBjbBCwo7LZeivpfa6LOKdT6JW/W8izOqIjENlkpamIBWg0Pcxx/1uZlRQ/KZs7of59FDmfkF218nvtx0HIGd93Z0PJ/qquIyPzm0UafuSKwMhEB35m5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=V/WjzeuK; arc=fail smtp.client-ip=52.101.43.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQwFU1TnAF/SH7QpbMkKvWe28KO43t2dBPlovDbU1cmxn5gTwaag6XR3dyQ5WnwSRxHeBjvE9dKBSfc5/3pM2wJnIbmEtdWs1YgD+WjwoyRTjmLXW9EqcwxX4e3kxYid0ufBPgcaBpK3Mjfaub7N5z1SBmgU2rw6os/KUNiOjYDUZSoc4nmcorESMyRgZGekkAvklcMD2qTvmL7KdqTRFDv4bu/Z/MUmJNzA3zq2z3opzsdla6m1XlNZtqdo7mPOVaBUyXV3mPcbOiHr19BSbRvXyTnwFvluYw6gnpE0vJ1XOGEQ7NLH6TvHxopSM1jaK9AOVKzk5V7WwkC92zdFzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPDtMP442gaYKlVh/Ls3N+heIJstnrgXbKV87aNODbc=;
 b=LRcxIo8au0Te0fsfM11ATmpDLY82ykCgU8LUjIBIKFv5tFJmcgUzlw+7R1/jTOkVlIZvR1tBEA3rNNVhG/k/+FZP/HrYMQK1pE5yRbwU++TT+kG1j8Y+/Z5kDZIQkV+5VTIrtJ10e26QwxEZ8CGhKQdo/BId3cqdUtAO2YPhGwVcy8FTyrRWp8Guw+28dkFIWxLEl2lJGgKjxANsmqZDenpEd0gWjhn9KWRUj9vuPtibLU/BFYGfJn2vJBqYmlA27U2gevLPNddrz9rvbfmwo+8h6nu0BBx+SaYSBpqPY0oEa+vrr8u8WBFj+eI5iik8W7snpDDfaWjosyp7sTYemg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPDtMP442gaYKlVh/Ls3N+heIJstnrgXbKV87aNODbc=;
 b=V/WjzeuKP1hg9a39/aTDj6iy/hgzjl8E7ZC0E4ixajRXWijjZR8zZZhbywThbNZLE3GbE1THThIF9tq1nH/Qe09WeG2njOpR45tYh7p7sZCzeVojwpLvst+iZjHOH+fB5jJX32C/Pavq5isB0Act3X2NoQFktxQdhnyuEBh8s7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from MW2PR0102MB3419.prod.exchangelabs.com (2603:10b6:302:5::13) by
 MW6PR01MB8577.prod.exchangelabs.com (2603:10b6:303:24b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.8; Thu, 5 Dec 2024 18:18:20 +0000
Received: from MW2PR0102MB3419.prod.exchangelabs.com
 ([fe80::28e1:2469:1811:caa2]) by MW2PR0102MB3419.prod.exchangelabs.com
 ([fe80::28e1:2469:1811:caa2%5]) with mapi id 15.20.8251.007; Thu, 5 Dec 2024
 18:18:20 +0000
Date: Thu, 5 Dec 2024 03:50:36 -0800
From: Darren Hart <darren@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Christoffer Dall <christoffer.dall@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: nv: Shadow stage-2 page table
 handling
Message-ID: <Z1GTjN3Ba0x1iKj9@Fedora>
References: <20240614144552.2773592-1-maz@kernel.org>
 <171878647493.242213.9111337124987897859.b4-ty@linux.dev>
 <46bea470-3a3b-4dcc-b4a8-a74830c66774@os.amperecomputing.com>
 <86plmov8n3.wl-maz@kernel.org>
 <38339ef8-6e69-43b5-8d16-b7fd66775c93@os.amperecomputing.com>
 <86o727um28.wl-maz@kernel.org>
 <871pz2th4b.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871pz2th4b.wl-maz@kernel.org>
X-ClientProxiedBy: MW4PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:303:8e::21) To MW2PR0102MB3419.prod.exchangelabs.com
 (2603:10b6:302:5::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR0102MB3419:EE_|MW6PR01MB8577:EE_
X-MS-Office365-Filtering-Correlation-Id: 8538d7f1-5c05-4b9c-1bea-08dd15593288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|7416014|1800799024|366016|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HuQT0PGjpn5QhunT4Z8tlYllTf+07Oe+n0RSXUARobMFjEfs4yGdNiHV+AgZ?=
 =?us-ascii?Q?J4t0REgTOlB8OyOJ1coMM1X6/7RGhezkxtbHYu6ptZvfWhVr/qCKzECLysb+?=
 =?us-ascii?Q?QpsfwqdooLdaZc1ACuBSmhM0b7ptYHm3vFQTwgzGGj4nWbkvAn/Zy3Bq1UGy?=
 =?us-ascii?Q?D75mW4LcMeAHPCp1Ay46itdaGViTx6sRAQ2NouBa2ZZ+TUDceqt7aOIHRItP?=
 =?us-ascii?Q?hRyiSZB6DKW//XO/bYCxtStbwdLePwUkVkhZ6S6OUKYAGtwchC7AznbBiwPD?=
 =?us-ascii?Q?h5OX+9ZxR9bNuJc8GFo1XC8uHdbBPmiEtDJthtcaIR9SQ+Su1v1fo6fMDE56?=
 =?us-ascii?Q?XsojWc3Rz8NuJcMVrixvgq/GCbDPpbBo4ON1K5sZlFT0Fi6qoWodrgff63hT?=
 =?us-ascii?Q?EGL66lUUkwl1TtpJnSDurIhQu/7HLfAhTQEvJ4NovOVEsRaMMdJ+NNPeD+6n?=
 =?us-ascii?Q?cJUhxbUA5ZZhJk+ZVc9wIEeyLgmjgdwycj/mmSV17COB9VBx8qj+pyqIPRNB?=
 =?us-ascii?Q?P8lF1sOMaoO43AsfhH0Uq9U0gPvYOedz/UOTnk3unzbj987GXIy6DQuyduaY?=
 =?us-ascii?Q?kYhoGSLSZpM9ya7QqdYmxoUrYixdAcy326NoVGjR+Z1qTgHcJ3NszdqI27SO?=
 =?us-ascii?Q?7lyn21jI//yxFXOTTGkH+c2Ri8+w6v6uaoc5QKMgXLe5Y5JBHkoQyka/ayT9?=
 =?us-ascii?Q?EduSvegzAKmWOul48fS2imNNldzZIVID+Kona5L+jQRvo95t0/cVXTj2TGRa?=
 =?us-ascii?Q?Q+R2VhrYx5ZO9X0tHzKjBqlMO5MkMYnr1hiSm0ctU0PuQFsDd7bQWD8Fi2uK?=
 =?us-ascii?Q?gL8fWy5WsLi1is2bLXJtUhDDZqlKxXkkPLA5iARxpM/dTaSTKQbsWf1raflb?=
 =?us-ascii?Q?b9uwtafWmUQsIbtMXkndjG2/ic6R5NXeRFQhdnbKqP8SXG/XM6go4eb7IGq7?=
 =?us-ascii?Q?lsBi6wiU3OQDdtMvYt5m2VTZEeLkOFvzXkZnD9mx9bHT5fcUu4DTWgueKY0u?=
 =?us-ascii?Q?4OoPPgTvOxEANkgLsJ95BCdWEJdAVoGpiul2HzR2HAdnDqRegClw2QP/lHxl?=
 =?us-ascii?Q?abK+43YL7htxH+zuA0yc3QRlLmjwNEmEthSbCfUpzL9pPfgGBkma3KMSyhC7?=
 =?us-ascii?Q?zPqmSKOfoEkNaM01sTOn6HJP9f6wv31o9Ps6hKMrgrMpuxynNCtB9aFy/glK?=
 =?us-ascii?Q?fIXSnzqpRk0S2I404BSkv2jJHUn7z1YYIOcIpHLgJRuXZiCHSBZaznPGwCr3?=
 =?us-ascii?Q?ySfm8kN8L3/TrzlVowUeFsJ3ZK0wiPhcNnRUh/XVmvtq9+Z4lxE+gzQ1FXJb?=
 =?us-ascii?Q?0BCJFXjgd0HTbSA6Y3XAIHaMJyulFft0nJNIxKpbxOmH1h/SNyL3EWwU0TkO?=
 =?us-ascii?Q?RpKZTjjAg+qxbBpMaWPIE2Kc5LFJ5AbbhdfPg376MpTZj4LBAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR0102MB3419.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(7416014)(1800799024)(366016)(7053199007)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+vFRob0Ubci9qp2lx9YKndADfQj7VqRtmG2fjBZkVC5W1YzPXKlQ9SWCm8tm?=
 =?us-ascii?Q?VU8YWFai7Dk8+h7vzP9fgZlgYJ3hIQAOOMJ+HWjv23xLNm5AP1awddpSTPl/?=
 =?us-ascii?Q?uf/vB6FBEQ6uUDz69FNI3k2HmYJtSnbDyd83kuFoC6czO/r27y1jQ2ZikTZQ?=
 =?us-ascii?Q?H+NNg5tWkhMAzuc5XqTB6/MqIA2XU2mVKJq4fUD1B+FIhCTsRmXHFtYqhnqB?=
 =?us-ascii?Q?EGlKt4l8sWhSuxHVTNBMnjB2V3OhcfBlXrzUNk2evt0O+ZoNdDMHKsLOA+TZ?=
 =?us-ascii?Q?N3lSuaN4jnOWiSZcZ91lp4PP/MMB1ts3pVXUg4Wbh9VAyw2nK4wIjcHLAqa6?=
 =?us-ascii?Q?poFbAiq64s1M/IL6pb4XbNVie++IB2j4He+CgpG5bhWNTxdx4VN3fJPnDHB6?=
 =?us-ascii?Q?XPqRgtttdkvyeuZ+GyFBPJN9WJ0bs+AeW/7aAGnaC5ZDjWYLdfB31a8zT7k3?=
 =?us-ascii?Q?/7Aeao9IHuyiPR3jdaei8hyvz6/GBFsi4pHkAKZQwHdkN1fCZdnOFnmqjUor?=
 =?us-ascii?Q?Hix3ZRNkxIfg+VqtN5TmNnQJTNLCCpHjhCl76k52cg2SufGN0JLZ2Yyq1NWN?=
 =?us-ascii?Q?fdqR+V5vINz5ZbAfLTJdQWSIuMWNwVB2sQozagE3Go8EgoQmfsD25fLQpofZ?=
 =?us-ascii?Q?+iUXPbY/J/g2K2UQrS0GNEkDDNcIW0ptHJwmaMW1hDfTQHX6XDQ+AHaMX+k+?=
 =?us-ascii?Q?Ye8rHOljW39DVlVWVlRCXDstkVGFmJvGef3/OHFYpIabWa2Zyo1zWSI6vfC3?=
 =?us-ascii?Q?s7lcwz5WVfwIwewZNSu2+XdRCv7qzXbXR97BVoyAMuIO17XYPMCXRpNvXUR5?=
 =?us-ascii?Q?776cdgT79xt/Kd0cD8nirOSZExaHG74UwM8td3HhEC9wvxJVUKaazURtS9VN?=
 =?us-ascii?Q?+4+11P3dEZkoELtAobgSnlEYfUVDfgzfJmwUcc/2H9N3+Is/XeJL9kmhH4hb?=
 =?us-ascii?Q?P8QS2JXJMYM0ytpyNF0GyTnu1d1jHmuPbUwaf0xOBaziIAdAvZoiAdqa6vzK?=
 =?us-ascii?Q?KHCibuHZW1PiAtsJrJXldGTRjzL6Tm5Fo9e0ae6MMUPuDYKyn2+lxU1OcXNN?=
 =?us-ascii?Q?VF5hikHbCXosRtH1KKR7rI9GjykOTzPBOPnYKq/OwNsr0VYWoZ0qoSdsqKka?=
 =?us-ascii?Q?Qac7/qiYk806eYmyJ+4GSl42GlWGkapXpyQBlx6OwyE0UB9Hp+uoXkZkO5Dh?=
 =?us-ascii?Q?ITwOBI9TuxtioO1X/gF4oXxnVlki9nzWVzluF+LKtKRFeMd/A8C3w4D/zAuw?=
 =?us-ascii?Q?wLZf4pPQIuZ+LjHAmjNlwpGE/KW3q39JoV/gqo2sMTcZLxgwr2DuheKMdhYj?=
 =?us-ascii?Q?1dW3u8KQSUZr7prpFo6CKZoX+9magubYFo+VaSNKXfkcIs5oZmHlv1I5v5/P?=
 =?us-ascii?Q?vs+v/O7KtfdhLtPe3FF9goMg3DWqQ/CNbt6I3846A5RH7ODqTjC9Bxj5iUA5?=
 =?us-ascii?Q?PGgruVVqIVEfVbBuIPLpES3PZt2qSOsM6AgUiV3fUaYZfvpHotre8prn5gfq?=
 =?us-ascii?Q?pTquR/TMPUSyC6qAmcZT7I0bN+udk8+KDgRWh7K+QlXd/VUPq4Eu06rZF5Sj?=
 =?us-ascii?Q?Z6hWkZ8SXBrsPUxKkq0ASUa6QWs5n/7gggn+GP8O3HH8N8LBmMcCYqsTUXPo?=
 =?us-ascii?Q?xHoV72iJ1UnBeQNBeGrCVoU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8538d7f1-5c05-4b9c-1bea-08dd15593288
X-MS-Exchange-CrossTenant-AuthSource: MW2PR0102MB3419.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 18:18:20.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHCKaHnCROrGhTY92njRtTrlSArxi1kWskCFj/1J9g4M49VvBESrxsp9FR8WbC2dG1fmyZ1qaxDob40u9qbqypoZa+bFHTuv8uCSjAb/zNbKIUv4sK/JxXhEUexBDiIT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR01MB8577

On Sat, Nov 23, 2024 at 09:49:08AM +0000, Marc Zyngier wrote:
> On Fri, 22 Nov 2024 19:04:47 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Fri, 22 Nov 2024 16:54:16 +0000,
> > Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
> > > 
> > > 
> > > 
> > > On 21-11-2024 10:14 pm, Marc Zyngier wrote:
> > > > On Thu, 21 Nov 2024 08:11:00 +0000,
> > > > Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
> > > > 
> > > > Hi Ganapatrao,
> > > > 
> > > >> IIRC, Most of the patches that are specific to NV have been merged
> > > >> upstream. However I do see that, some of the vGIC and Timer related
> > > >> patches are still in your private NV repository. Can these patches be
> > > >> prioritized to upstream, so that we can have have the first working
> > > >> version of NV on mainline.
> > > > 
> > > > Who is *we*?
> > > > 
> > > > Things get upstreamed when we (people doing the actual work) decide
> > > > they are ready. At the moment, they are not.
> > > > 
> > > > Also, while I enjoy working on NV, this isn't *my* priority.
> > > 
> > > Sure, I understand that it's not your priority right now.  I'm happy
> > > to spend some time on it, please do let us know in what areas/patches
> > > needs attention before the code would be ready to merge?
> > 
> > Please understand that NV isn't special, and while there is still a
> > bunch of things that need to be merged, it is the whole of KVM/arm64
> > that needs attention.
> > 
> > For example, there is the debug series from Oliver, the feature
> > handling from Fuad. They may not have NV written all over them, but
> > they do have an impact on the NV behaviour one way or another.
> > 
> > By paying attention to these series, you would help with the
> > groundwork that is required before we can actually enable NV. This is
> > what matters now, not the next 50 or so NV-specific patches.
> 
> And one last thing, while I think of it: NV is very unlikely to get
> merged without a testing infrastructure. Which means that the current
> selftests must run at EL2, and that *new* selftests must be created to
> test the NV implementation (all the trap behaviours, for example).
> 
> So if you (and I assume your employer, as you keep using the plural)
> want to help moving NV support upstream, this is an area where you
> could help and make a massive difference.

Appreciate the specific examples Marc, thank you. I'll work with my team
at Ampere in this direction - specifically the testing infrastructure
work and engaging in the NV-adjacent kvm patche series.

-- 
Darren Hart
Ampere Computing / Linux Enabling

