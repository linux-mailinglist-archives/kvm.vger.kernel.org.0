Return-Path: <kvm+bounces-65476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1D4CABEEA
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 04:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 518BF3005092
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 03:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A782FC897;
	Mon,  8 Dec 2025 03:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="hqaPaYjA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBD92853EF;
	Mon,  8 Dec 2025 03:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765163506; cv=none; b=fcZB6/va6vPQ9H6L0r1kfRZEn3AW+fbXg5A2V3Eg/mg8Y+U1vwdtVwS2jyJInjzRCqIYVG9m0xm2jc6vCa+fD//9hqvnKzjoda430uOwmH/W75nVKfdzRDwQd2k/yQ/uGPWYPyM7KAzCzgnjr1hcgtHUwB/wuGORJc/7cHKd3FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765163506; c=relaxed/simple;
	bh=PWVkiDEC87gkl3WeqYtJOi1H9NKFiIafL6d70O9h9dk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NF7UFh4weqCkFZZK0ky6TqX8dxbJgSjX1SVEV/nsHl706ChVjhgPk+oMauqg66T9c1pAsDbnOx46Ae2MugAkVnm+BU8XLoQnesEULFiPVnCt6lxY10xrW79jBCwXoY0pWMel7lw8MLd3Oa9xCJ0NgplMJPx6yBrTMifObFntzw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=hqaPaYjA; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B7NFkRA217946;
	Sun, 7 Dec 2025 19:11:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Vd6Iz1i7itJ92zcgMPFF
	3i5AUH9Px70FcbBba7Gfk6M=; b=hqaPaYjAlt9ijhOTPQmQOTzQj2qeNXJost3q
	DWaewwUgsDwIXC70YkMc5vZywxyQN0xQD86SElBn4yASIJ8WF57OIOUvVH6QJ1x7
	Vl/SDrGoD9IngZwCcS6Cxxp52ACtYW2WQHLtPAxnhgaw/m/kY2LlZc25fgks8YR3
	gm/RDHmQ9Su5vI0mbZJ5ilGszdfwRPGbEjiCZDJaueckzMrSPUoh7902mxi6pj7o
	+MBNXQEodgp/gc9RrzVNUlj4+pbHwGAtx+FTgBk2jnvau3lpocBy5nOEL981sz+g
	JJI3ORqZpPjkk0q04u0KWOfhzWkMdvj+vFAJ52/rP5VMe5aiFA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4avhd5784v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 07 Dec 2025 19:11:32 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Mon, 8 Dec 2025 03:11:30 +0000
Date: Sun, 7 Dec 2025 19:11:25 -0800
From: Alex Mastro <amastro@fb.com>
To: Peter Xu <peterx@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        Nico Pache
	<npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
        David Hildenbrand
	<david@redhat.com>,
        Alex Williamson <alex@shazbot.org>, Zhi Wang
	<zhiw@nvidia.com>,
        David Laight <david.laight.linux@gmail.com>,
        Yi Liu
	<yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
        Kevin Tian
	<kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aTZB3VFArpJJMKMN@devgpu015.cco6.facebook.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>
X-Authority-Analysis: v=2.4 cv=ZIPaWH7b c=1 sm=1 tr=0 ts=693641e4 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cCa_CVtDXYSc011Sr6sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: i1OkR2zPIMdJjvRRdpVqF_xjZi1juKv5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDAyNSBTYWx0ZWRfX5nK+Tc/ZJJsi
 QhadGeGPvSVp4T22yoZpnRWgwVPvXIObvTMLv/q5HpmzEZ9aAbwzhIqHBWCp/QIGaBmDfuJref1
 M6e9US7i0Zap/5ba16bT8drdORPBRsp/ijkfkWcc5kVe+sQuSyp7A2LKKuSfwpcSCuVawQq5MCa
 cwnUKALCjyJ+dSlOXUDnI0/jANwfFjarErArnOQO+TLf/kOmDc7ARoHladPfiZz9rdvpcCR0lGM
 lvnPrmVJVz7jIL8OOrcfy903DNdunbEWn4fshx8Rmr/ZQElJ2wr4+QiixNQwJlbQizQVabQdg64
 giEypRJBLACssjRlqeyqwLJxcAO8c5eg5pui/UiNtIPW1Cq0pRmmM5URPCRLBA+7C8j680Pqthb
 GPfaVMG4dr5wOYy0nxktuOJmRrneUQ==
X-Proofpoint-ORIG-GUID: i1OkR2zPIMdJjvRRdpVqF_xjZi1juKv5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01

On Thu, Dec 04, 2025 at 10:10:03AM -0500, Peter Xu wrote:
> To achieve that, a custom vfio_device's get_mapping_hint() for vfio-pci
> devices is needed.

nit get_mapping_order() 

