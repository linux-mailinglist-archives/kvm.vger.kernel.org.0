Return-Path: <kvm+bounces-23659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E533994C6E7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 00:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F3D1C2161A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 22:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A424515ECD2;
	Thu,  8 Aug 2024 22:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="l3BH/IeB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230FF155C8E;
	Thu,  8 Aug 2024 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155383; cv=none; b=j4bkG7XdogxstjllAdX7UXYuQJevQpo+S+Vel3xXyoOrO7mxbMoP9XMqwrCgIhsbnhRVsb0y4u+J7hfQ56BIt4BfWBJNYYhBhebC9iSfh8o+PB3oqI5nb0auMg8Pdt6xs1uvw2Oh0we0kvU2sHmsyQLQllQsp/AezTTayPvHKY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155383; c=relaxed/simple;
	bh=t63ZZLDq2/nQ+VQGBPCg/bW2uLKB2nNZHE/2yk+Lm84=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqZCgjxdUJWq0vrO0HqTFpp05YXORXQQIewWwPyPCqZ4JU9WnocKLbOd6ANExczoIThPRFAsGFmOv2+cUCume/XsqNtha9vqVsBVYY6BSYwghfum+YhMElDtp+qzp+LpGZttNCHF1eCEww7RTZVRWN7Yqd8OAEbm8pruLvofpv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=l3BH/IeB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478MBSST008155;
	Thu, 8 Aug 2024 22:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=nL3u+k6A/dv1Xe3KTcQ29Mj4
	89OIsNIerAdn3j53pCs=; b=l3BH/IeBBggrLBFKC1idrJciacBCPcGIDLjA4B/t
	VQnrImxCDtchrkq/5hVgbGghWUWc6LMuA0iS7zK+IK8fg2itNrrheLwP7UT/YtxE
	eBRBLcLoyx6eaJSAnGU5nZvjkzk+NSM4nOq+EmCTfW+kFcOYNJFxx/mzoXRpdFTr
	sIC7gjTWSiWYQI2p2lrag2BzId8iaFZc3kzpQYYyPFgLX4cKJdaUcTPUSEXLv0XR
	dyqlbT+nc0GnXqhDPSP5DnKRvGBV606TxhNl3e3iKMA9kHa7LAAwsr2rnPJ2Hisy
	SbAca2/hy0FYSmAffdvR3hmEb4RLp51uqAUL7xwFsDB49Q==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40vfy5bej0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 22:16:11 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 478MGA6T016945
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 8 Aug 2024 22:16:10 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 8 Aug 2024 15:16:09 -0700
Date: Thu, 8 Aug 2024 15:16:09 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Patrick Roy <roypat@amazon.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        <qperret@google.com>, Ackerley Tng <ackerleytng@google.com>,
        <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, James Gowans <jgowans@amazon.com>,
        "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>,
        "Manwaring, Derek" <derekmn@amazon.com>,
        "Cali,
 Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
Message-ID: <20240808145103617-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
 <3fc11402-53e1-4325-a3ee-5ebd616b5b63@amazon.co.uk>
 <20240806104702482-0700.eberman@hu-eberman-lv.qualcomm.com>
 <a43ae745-9907-425f-b09d-a49405d6bc2d@amazon.co.uk>
 <90886a03-ad62-4e98-bc05-63875faa9ccc@amazon.co.uk>
 <20240807113514068-0700.eberman@hu-eberman-lv.qualcomm.com>
 <7166d51c-7757-44f2-a6f8-36da3e86bf90@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7166d51c-7757-44f2-a6f8-36da3e86bf90@amazon.co.uk>
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: BV9dcG3O0hDNp8CTu0jKw-Sde_t8cyjh
X-Proofpoint-ORIG-GUID: BV9dcG3O0hDNp8CTu0jKw-Sde_t8cyjh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_22,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408080159

On Thu, Aug 08, 2024 at 02:05:55PM +0100, Patrick Roy wrote:
> On Wed, 2024-08-07 at 20:06 +0100, Elliot Berman wrote:
> >>>>>>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
> >>>>>>  {
> >>>>>> +       unsigned long gmem_flags = (unsigned long)file->private_data;
> >>>>>>         struct inode *inode = file_inode(file);
> >>>>>>         struct guest_memfd_operations *ops = inode->i_private;
> >>>>>>         struct folio *folio;
> >>>>>> @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >>>>>>                         goto out_err;
> >>>>>>         }
> >>>>>>
> >>>>>> +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> >>>>>> +               r = guest_memfd_folio_private(folio);
> >>>>>> +               if (r)
> >>>>>> +                       goto out_err;
> >>>>>> +       }
> >>>>>> +
> >>>>>
> >>>>> How does a caller of guest_memfd_grab_folio know whether a folio needs
> >>>>> to be removed from the direct map? E.g. how can a caller know ahead of
> >>>>> time whether guest_memfd_grab_folio will return a freshly allocated
> >>>>> folio (which thus needs to be removed from the direct map), vs a folio
> >>>>> that already exists and has been removed from the direct map (probably
> >>>>> fine to remove from direct map again), vs a folio that already exists
> >>>>> and is currently re-inserted into the direct map for whatever reason
> >>>>> (must not remove these from the direct map, as other parts of
> >>>>> KVM/userspace probably don't expect the direct map entries to disappear
> >>>>> from underneath them). I couldn't figure this one out for my series,
> >>>>> which is why I went with hooking into the PG_uptodate logic to always
> >>>>> remove direct map entries on freshly allocated folios.
> >>>>>
> >>>>
> >>>> gmem_flags come from the owner. If the caller (in non-CoCo case) wants
> >>
> >> Ah, oops, I got it mixed up with the new `flags` parameter.
> >>
> >>>> to restore the direct map right away, it'd have to be a direct
> >>>> operation. As an optimization, we could add option that asks for page in
> >>>> "shared" state. If allocating new page, we can return it right away
> >>>> without removing from direct map. If grabbing existing folio, it would
> >>>> try to do the private->shared conversion.
> >>
> >> My concern is more with the implicit shared->private conversion that
> >> happens on every call to guest_memfd_grab_folio (and thus
> >> kvm_gmem_get_pfn) when grabbing existing folios. If something else
> >> marked the folio as shared, then we cannot punch it out of the direct
> >> map again until that something is done using the folio (when working on
> >> my RFC, kvm_gmem_get_pfn was indeed called on existing folios that were
> >> temporarily marked shared, as I was seeing panics because of this). And
> >> if the folio is currently private, there's nothing to do. So either way,
> >> guest_memfd_grab_folio shouldn't touch the direct map entry for existing
> >> folios.
> >>
> >
> > What I did could be documented/commented better.
> 
> No worries, thanks for taking the time to walk me through understanding
> it!
> 
> > If ops->accessible() is *not* provided, all guest_memfd allocations will
> > immediately remove from direct map and treat them immediately like guest
> > private (goal is to match what KVM does today on tip).
> 
> Ah, so if ops->accessible() is not provided, then there will never be
> any shared memory inside gmem (like today, where gmem doesn't support
> shared memory altogether), and thus there's no problems with just
> unconditionally doing set_direct_map_invalid_noflush in
> guest_memfd_grab_folio, because all existing folios already have their
> direct map entry removed. Got it!
> 
> > If ops->accessible() is provided, then guest_memfd allocations start
> > as "shared" and KVM/Gunyah need to do the shared->private conversion
> > when they want to do the private conversion on the folio. "Shared" is
> > the default because that is effectively a no-op.
> > For the non-CoCo case you're interested in, we'd have the
> > ops->accessible() provided and we wouldn't pull out the direct map from
> > gpc.
> 
> So in pKVM/Gunyah's case, guest memory starts as shared, and at some
> point the guest will issue a hypercall (or similar) to flip it to
> private, at which point it'll get removed from the direct map?
> 
> That isn't really what we want for our case. We consider the folios as
> private straight away, as we do not let the guest control their state at
> all. Everything is always "accessible" to both KVM and userspace in the
> sense that they can just flip gfns to shared as they please without the
> guest having any say in it.
> 
> I think we should untangle the behavior of guest_memfd_grab_folio from
> the presence of ops->accessible. E.g.  instead of direct map removal
> being dependent on ops->accessible we should have some
> GRAB_FOLIO_RETURN_SHARED flag for gmem_flags, which is set for y'all,
> and not set for us (I don't think we should have a "call
> set_direct_map_invalid_noflush unconditionally in
> guest_memfd_grab_folio" mode at all, because if sharing gmem is
> supported, then that is broken, and if sharing gmem is not supported
> then only removing direct map entries for freshly allocated folios gets
> us the same result of "all folios never in the direct map" while
> avoiding some no-op direct map operations).
> 
> Because we would still use ->accessible, albeit for us that would be
> more for bookkeeping along the lines of "which gfns does userspace
> currently require to be in the direct map?". I haven't completely
> thought it through, but what I could see working for us would be a pair
> of ioctls for marking ranges accessible/inaccessible, with
> "accessibility" stored in some xarray (somewhat like Fuad's patches, I
> guess? [1]).
> 
> In a world where we have a "sharing refcount", the "make accessible"
> ioctl reinserts into the direct map (if needed), lifts the "sharings
> refcount" for each folio in the given gfn range, and marks the range as
> accessible.  And the "make inaccessible" ioctl would first check that
> userspace has unmapped all those gfns again, and if yes, mark them as
> inaccessible, drop the "sharings refcount" by 1 for each, and removes
> from the direct map again if it held the last reference (if userspace
> still has some gfns mapped, the ioctl would just fail).
> 

I am warming up to the sharing refcount idea. How does the sharing
refcount look for kvm gpc?

> I guess for pKVM/Gunyah, there wouldn't be userspace ioctls, but instead
> the above would happen in handlers for share/unshare hypercalls. But the
> overall flow would be similar. The only difference is the default state
> of guest memory (shared for you, private for us). You want a
> guest_memfd_grab_folio that essentially returns folios with "sharing
> refcount == 1" (and thus present in the direct map), while we want the
> opposite.
> 
> So I think something like the following should work for both of us
> (modulo some error handling):
> 
> static struct folio *__kvm_gmem_get_folio(struct file *file, pgoff_t index, bool prepare, bool *fresh)
> {
>     // as today's kvm_gmem_get_folio, except
>     ...
>     if (!folio_test_uptodate(folio)) {
>         ...
>         if (fresh)
>             *fresh = true
>     }
>     ...
> }
> 
> struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index, bool prepare)
> {
>     bool fresh;
>     unsigned long gmem_flags = /* ... */
>     struct folio *folio = __kvm_gmem_get_folio(file, index, prepare, &fresh);
>     if (gmem_flag & GRAB_FOLIO_RETURN_SHARED != 0) {
>         // if "sharing refcount == 0", inserts back into direct map and lifts refcount, otherwise just lifts refcount
>         guest_memfd_folio_clear_private(folio);
>     } else {
>         if (fresh)
>             guest_memfd_folio_private(folio);
>     }
>     return folio;
> }
> 
> Now, thinking ahead, there's probably optimizations here where we defer
> the direct map manipulations to gmem_fault, at which point having a
> guest_memfd_grab_folio that doesn't remove direct map entries for fresh
> folios would be useful in our non-CoCo usecase too. But that should also
> be easily achievable by maybe having a flag to kvm_gmem_get_folio that
> forces the behavior of GRAB_FOLIO_RETURN_SHARED, indendently of whether
> GRAB_FOLIO_RETURN_SHARED is set in gmem_flags.
> 
> How does that sound to you?
> 

Yeah, I think this is a good idea.

I'm also thinking to make a few tweaks to the ops structure:

struct guest_memfd_operations {
        int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
        void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
        int (*prepare_accessible)(struct inode *inode, struct folio *folio);
        int (*prepare_private)(struct inode *inode, struct folio *folio);
        int (*release)(struct inode *inode);
};

When grabbing a folio, we'd always call either prepare_accessible() or
prepare_private() based on GRAB_FOLIO_RETURN_SHARED. In the
prepare_private() case, guest_memfd can also ensure the folio is
unmapped and not pinned. If userspace tries to grab the folio in
pKVM/Gunyah case, prepare_accessible() will fail and grab_folio returns
error. There's a lot of details I'm glossing over, but I hope it gives
some brief idea of the direction I was thinking.

In some cases, prepare_accessible() and the invalidate_*() functions
might effectively be the same thing, except that invalidate_*() could
operate on a range larger-than-a-folio. That would be useful becase we
might offer optimization to reclaim a batch of pages versus e.g.
flushing caches every page.

Thanks,
Elliot

