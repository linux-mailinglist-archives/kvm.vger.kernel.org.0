Return-Path: <kvm+bounces-60688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3C9BF7A58
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CF3334FCFAB
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D183491D1;
	Tue, 21 Oct 2025 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="3mN1nDvv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE163451AF
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761063965; cv=none; b=jT2NOS0B35a8wOurWx4ouLZi7SX7rFwK0DHXr78lgh+51rG/eHpm5j3nPHtWIdezzGukBEAedturbAMZF2minw/AUtyjLfF7Br0cyfjS9oTs4B8DECG3d1JJZbfrPqctTbil2dmE6iZqSJacxt1vk9j4ws8sXA/mAUy5z+ydI98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761063965; c=relaxed/simple;
	bh=6R1KW03BlAqZIPkPdTpbrLdRFVQw9kdpmHbWu/eh0hU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIHI1jnFByhQt3G9qBYxHlACR1jzY88ZGZ8HBHd/+SLhvry8JFZvQSrpoOcMiZGooxGErtM8zrrGxg1rFf3yUS4RjoRi+BZMWz3tNcKGbWLOUA0OmJxO5au44LiB3J1UWBgXCwwHlAYA0NljfApxXK0SvdJafBVxhEuY6fHhsk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=3mN1nDvv; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59LBnHKj2956007
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:26:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=uixxVY5jBxz7ifOxrNlz
	AIr93OBtbXeTLIuJeKqDRW8=; b=3mN1nDvvW2b3puZIQm3jI4O186+QpPjneWHI
	lcbJcimLisZD2dwjjxnP81e/Fya53QRoVsWDnBw68h6JTKw3rCyRfWjN/kX+neWM
	tkZsnQnIKn+kk/rZ43JvmNIVAFUQi6JVsCmmNAdRRPLFd+6GHJ3KlT+UQz0olWBL
	KW9WDdq6Npp3vrBP6q6PRSU75LBB25vsPZ2kRsn2geEs2PFJjoyQ/nk8eyV8eLdd
	NfP9XB0UjOOy4z7ygRsmqTzkqq2IJKIHNIVIa82PK65pq+qyGxkJq87uS1ydFa0r
	4Lfi32K+1kNl09wwyByrpwUOS1wfrSc7g3IRHM6+FOHc2q7NiQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49x9mwa82r-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:26:00 -0700 (PDT)
Received: from twshared51336.15.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 21 Oct 2025 16:25:59 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 23751)
	id 49A5D4D1322; Tue, 21 Oct 2025 09:25:55 -0700 (PDT)
Date: Tue, 21 Oct 2025 09:25:55 -0700
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David
 Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
 <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org>
 <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251020153633.33bf6de4@shazbot.org>
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIxMDEyOSBTYWx0ZWRfXy+Kt9xMiR1EL
 M/zllaVVCSvsiftBd9jlWHU5DFGU3R+n1qc8iXshCS/GkyApDY/aThDLYtqVhJue9zrJrxMy7vZ
 9qKQqy1NEkzrCdm81E87KsK4qwyAKW9xLv0Jatzb6weFkwLMzqH34dOpOp+bugFZOe9JokM64xP
 lIw70rkHi/SCes+9m75ZPMD4gg2pO0dOotJW9r9glYgmI0FSzVzDTmg+tgO2zUBCyJY1AtXYhnp
 XuKKTorGmyfTC23oH8nr/DIK4+S/woOlNrSRgHUZhlxJ2UlJ/WvUowQtIj29uJWZUCVvo0gEpvj
 K2+KkDUL9EbDBaFpB5kIhlsh7YpEGb7TJdg7Zl1aAZuPjolJ5sgw7e6DtjDQ0hX+mIOjrc/DwdN
 WYNh9skuhx1njU7Tk7sCJ7srV5Ytvg==
X-Authority-Analysis: v=2.4 cv=f/dFxeyM c=1 sm=1 tr=0 ts=68f7b418 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=PJXvXVaVCeDa2e8N594A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: G3DUtzMPT7-l2m--pXG5bQpkgHvIUpL0
X-Proofpoint-ORIG-GUID: G3DUtzMPT7-l2m--pXG5bQpkgHvIUpL0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01

On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:
> I do note that we're missing a Fixes: tag.  I think we've had hints of
> this issue all the way back to the original implementation, so perhaps
> the last commit should include:
> 
> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")

SGTM

> Unless you've identified a more specific target.

I have not.

> Along with the tag, it would probably be useful in that same commit to
> expand on the scope of the issue in the commit log.  I believe we allow
> mappings to be created at the top of the address space that cannot be
> removed via ioctl, but such inconsistency should result in an
> application error due to the failed ioctl and does not affect cleanup
> on release.

Makes sense. I will clarify the commit msg in v5 to be more specific about what
this series changes relative to existing functionality.

> Should we also therefore expand the DMA mapping tests in
> tools/testing/selftests/vfio to include an end of address space test?

Yes. I will append such a commit to the end of the series in v5. Our VFIO tests
are built on top of a hermetic rust wrapper library over VFIO ioctls, but they
aren't quite ready to be open sourced yet.


