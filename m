Return-Path: <kvm+bounces-67631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 10112D0BCAF
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 19:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 153A0303364C
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 18:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2EC366DCA;
	Fri,  9 Jan 2026 18:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F7M90pzn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4DD365A19
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 18:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767982028; cv=none; b=MBsLs7vwULKNvMKTFEUlqybSXiHNWOMAK6wQvAVAyeWr9oNR8GCTLUVp/ayfk3xlkn0sAhNZI2dCvSRy8lxQaFWtqRfWuASYBBoREpMZtTmCsQF4L8DVKfJo9bevUi0BkrJpft37peWbxExuaAKpAdJ9AKdcF+6kqm15WU4b0TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767982028; c=relaxed/simple;
	bh=9ZH1v3ibc0h2jxppU+OPj4pN7ltzsQ4XAWJQs3bnAg8=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/OhR9PD0Yodxt27gbJxe9LSApxh3FrrT1jN25hEtIN85b09FWpcYmjdPQB85hORiARjPHBMbUN836SVwwZO3NOV5ieJdBmyDpb/xLWcVPsyp8Qem/AgGfYa9BgRe1e3cRd25fF8mxUM9znqka7l59mJG6RreQBV0yVIMAL6P9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F7M90pzn; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59b786b2a5dso2640605e87.3
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 10:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767982024; x=1768586824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtV4EhFA1cbBmu55+5t5BYQ0dPk2vsfkGvr52LU9d/U=;
        b=F7M90pznLA0UjHFXWVncOWbnE1odhRnd/Ha/DKBWLbXQgTFeEkUfoGTlF+8THvFuZr
         O0GSXoEbuW9ggtIhv+5JOCpIvtFYNsGijQ0J1i/FWWzTDeVACJi/8wqfro8k3lNykt7h
         KGLiK7mrmJ3rYLhXflpar6QiwJDCibUBzWXPhM4Dt1H6kNTUd3PNgDFbV3341Ojd+VhE
         aKwSDNTChOR+bvhy8E82k5WGH1frA2UdZMXp+VGfDhx6FHZhpCM3hPU7XDV+dO5r4pac
         mmFdR8u/wfwwjVMPjc3Bg9mf8lv26rZRngNH/CP+Kc6esiW9OP1CENGktcECLcGJhZtt
         ozig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767982024; x=1768586824;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtV4EhFA1cbBmu55+5t5BYQ0dPk2vsfkGvr52LU9d/U=;
        b=PPSeuB5Iy2LNEw9f9jO7OYgLnQO8HK1FULygNzYD0Vh5f+7Jq872kcX1PKNJ366AuN
         k732jxC2WYQH+oGSoUZu/A7tzrfKf3cL4bI22pDKf9NvIjjPjNnoGM/iHY+TtyQLjoNz
         SJBT3r6UWrwl2cdVLJDrrS1AVsyLRaHC9LA5LPX3Pom47dtso+IpSLZ0fbnPu+YzLD5k
         98gb7uULGscf1FfrV1MBZoUMTxtoGWCxdBAdpLrjZ1BVtLyXPc4rnVZ3ufGI6Q7yJXF/
         NvFtK1bjVjIg37t/fZrhkch0ydI06Riloo3C/fluWtGD7MSTJ5tRtIotJe0GnKTc7HOR
         IACQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqcMhJvpfpc93J7sDxvIj+BH1mZ0NOaB2v5IjigAIGGKlansOv9jZPs2h9y8ad1CA5KKc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1hTSIVuXForlRJuIpCQz65VKp0fwOjttV1UWfn9PDnJmAA2SL
	+76Lp5DcKiS9/Go0f58icdBEhIPAlzHZrDdBuK0lth+pAmEOdhwhAA9Tja1et+NNaP4TSXbiJbh
	67FZXVs81wLRdnNT7P7uIUq/1B3e3ZqEsmED0QviG
X-Gm-Gg: AY/fxX6dEyRqnq+bKc/dzRc7hKQaDT99GaKOYjODJhapGU1J3v34ftuXs0ByHhskd3Z
	yLda+AvR+e0PRPm6GkqhfnB/TeoXf130ZEbSi2gSA3/BXLjV1CSWWUU91DJ0C6A/FGXqCNdEUmd
	tLjmbEuS44ed8EWYOti6nSyKXQQHiOjpt84OSfEkXsI9erbUfUtnb13p+6bMcoBRhZlnlXzjKuV
	BEZ6/+dTQoYTMbH7YniR2KeA86PAB9l4J8QtoBegqt6ubAHlTwCiubTHjEHvVdNaXa8E5sruWwD
	stM6tTekFaMze/JfLsI18EGyA6rbO7q6BpG+
X-Google-Smtp-Source: AGHT+IG0+Lsc92vNXZ3lDLxgk6iCsjUJ3s6dBH0IAPLmmT7Z9F1vlV4NDyrVfvBG4qybEMrdPLYwbGxUnsYvuXIKOLs=
X-Received: by 2002:a05:6512:6d4:b0:598:fab6:442f with SMTP id
 2adb3069b0e04-59b6ebd30cdmr3178839e87.0.1767982024087; Fri, 09 Jan 2026
 10:07:04 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 9 Jan 2026 10:07:00 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 9 Jan 2026 10:07:00 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com> <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com> <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 9 Jan 2026 10:07:00 -0800
X-Gm-Features: AQt7F2qzOO_XfBPzmPAD2W6ElvJTfDLqFMRALHvXyTAfiLaNDWU217YGIhSjhTs
Message-ID: <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, michael.roth@amd.com, 
	david@kernel.org, sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Vishal Annapurve <vannapurve@google.com> writes:

> On Fri, Jan 9, 2026 at 1:21=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>>
>> On Thu, Jan 08, 2026 at 12:11:14PM -0800, Ackerley Tng wrote:
>> > Yan Zhao <yan.y.zhao@intel.com> writes:
>> >
>> > > On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
>> > >> On Tue, Jan 06, 2026, Ackerley Tng wrote:
>> > >> > Sean Christopherson <seanjc@google.com> writes:
>> > >> >
>> > >> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
>> > >> > >> Vishal Annapurve <vannapurve@google.com> writes:
>> > >> > >>
>> > >> > >> > On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@=
intel.com> wrote:
>> > >> > >> >>
>> > >> > >> >> - EPT mapping size and folio size
>> > >> > >> >>
>> > >> > >> >>   This series is built upon the rule in KVM that the mappin=
g size in the
>> > >> > >> >>   KVM-managed secondary MMU is no larger than the backend f=
olio size.
>> > >> > >> >>
>> > >> > >>
>> > >> > >> I'm not familiar with this rule and would like to find out mor=
e. Why is
>> > >> > >> this rule imposed?
>> > >> > >
>> > >> > > Because it's the only sane way to safely map memory into the gu=
est? :-D
>> > >> > >
>> > >> > >> Is this rule there just because traditionally folio sizes also=
 define the
>> > >> > >> limit of contiguity, and so the mapping size must not be great=
er than folio
>> > >> > >> size in case the block of memory represented by the folio is n=
ot contiguous?
>> > >> > >
>> > >> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping s=
ize was (and still
>> > >> > > is) strictly bound by the host mapping size.  That's handles co=
ntiguous addresses,
>> > >> > > but it _also_ handles contiguous protections (e.g. RWX) and oth=
er attributes.
>> > >> > >
>> > >> > >> In guest_memfd's case, even if the folio is split (just for re=
fcount
>> > >> > >> tracking purposese on private to shared conversion), the memor=
y is still
>> > >> > >> contiguous up to the original folio's size. Will the contiguit=
y address
>> > >> > >> the concerns?
>> > >> > >
>> > >> > > Not really?  Why would the folio be split if the memory _and it=
s attributes_ are
>> > >> > > fully contiguous?  If the attributes are mixed, KVM must not cr=
eate a mapping
>> > >> > > spanning mixed ranges, i.e. with multiple folios.
>> > >> >
>> > >> > The folio can be split if any (or all) of the pages in a huge pag=
e range
>> > >> > are shared (in the CoCo sense). So in a 1G block of memory, even =
if the
>> > >> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
>> > >> > would be split, and the split folios are necessary for tracking u=
sers of
>> > >> > shared pages using struct page refcounts.
>> > >>
>> > >> Ahh, that's what the refcounting was referring to.  Gotcha.
>> > >>
>> > >> > However the split folios in that 1G range are still fully contigu=
ous.
>> > >> >
>> > >> > The process of conversion will split the EPT entries soon after t=
he
>> > >> > folios are split so the rule remains upheld.
>> >
>> > Correction here: If we go with splitting from 1G to 4K uniformly on
>> > sharing, only the EPT entries around the shared 4K folio will have the=
ir
>> > page table entries split, so many of the EPT entries will be at 2M lev=
el
>> > though the folios are 4K sized. This would be last beyond the conversi=
on
>> > process.
>> >
>> > > Overall, I don't think allowing folios smaller than the mappings whi=
le
>> > > conversion is in progress brings enough benefit.
>> > >
>> >
>> > I'll look into making the restructuring process always succeed, but of=
f
>> > the top of my head that's hard because
>> >
>> > 1. HugeTLB Vmemmap Optimization code would have to be refactored to
>> >    use pre-allocated pages, which is refactoring deep in HugeTLB code
>> >
>> > 2. If we want to split non-uniformly such that only the folios that ar=
e
>> >    shared are 4K, and the remaining folios are as large as possible (P=
MD
>> >    sized as much as possible), it gets complex to figure out how many
>> >    pages to allocate ahead of time.
>> >
>> > So it's complex and will probably delay HugeTLB+conversion support eve=
n
>> > more!
>> >
>> > > Cons:
>> > > (1) TDX's zapping callback has no idea whether the zapping is caused=
 by an
>> > >     in-progress private-to-shared conversion or other reasons. It al=
so has no
>> > >     idea if the attributes of the underlying folios remain unchanged=
 during an
>> > >     in-progress private-to-shared conversion. Even if the assertion =
Ackerley
>> > >     mentioned is true, it's not easy to drop the sanity checks in TD=
X's zapping
>> > >     callback for in-progress private-to-shared conversion alone (whi=
ch would
>> > >     increase TDX's dependency on guest_memfd's specific implementati=
on even if
>> > >     it's feasible).
>> > >
>> > >     Removing the sanity checks entirely in TDX's zapping callback is=
 confusing
>> > >     and would show a bad/false expectation from KVM -- what if a hug=
e folio is
>> > >     incorrectly split while it's still mapped in KVM (by a buggy gue=
st_memfd or
>> > >     others) in other conditions? And then do we still need the check=
 in TDX's
>> > >     mapping callback? If not, does it mean TDX huge pages can stop r=
elying on
>> > >     guest_memfd's ability to allocate huge folios, as KVM could stil=
l create
>> > >     huge mappings as long as small folios are physically contiguous =
with
>> > >     homogeneous memory attributes?
>> > >
>> > > (2) Allowing folios smaller than the mapping would require splitting=
 S-EPT in
>> > >     kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may arg=
ue that the
>> > >     invalidate lock held in __kvm_gmem_set_attributes() could guard =
against
>> > >     concurrent kvm_gmem_error_folio(), it still doesn't seem clean a=
nd looks
>> > >     error-prone. (This may also apply to kvm_gmem_migrate_folio() po=
tentially).
>> > >
>> >
>> > I think the central question I have among all the above is what TDX
>> > needs to actually care about (putting aside what KVM's folio size/memo=
ry
>> > contiguity vs mapping level rule for a while).
>> >
>> > I think TDX code can check what it cares about (if required to aid
>> > debugging, as Dave suggested). Does TDX actually care about folio size=
s,
>> > or does it actually care about memory contiguity and alignment?
>> TDX cares about memory contiguity. A single folio ensures memory contigu=
ity.
>
> In this slightly unusual case, I think the guarantee needed here is
> that as long as a range is mapped into SEPT entries, guest_memfd
> ensures that the complete range stays private.
>
> i.e. I think it should be safe to rely on guest_memfd here,
> irrespective of the folio sizes:
> 1) KVM TDX stack should be able to reclaim the complete range when unmapp=
ing.
> 2) KVM TDX stack can assume that as long as memory is mapped in SEPT
> entries, guest_memfd will not let host userspace mappings to access
> guest private memory.
>
>>
>> Allowing one S-EPT mapping to cover multiple folios may also mean it's n=
o longer
>> reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
>> contiguous range larger than the page's folio range.
>
> What's the issue with passing the (struct page*, unsigned long nr_pages) =
pair?
>
>>
>> Additionally, we don't split private mappings in kvm_gmem_error_folio().
>> If smaller folios are allowed, splitting private mapping is required the=
re.

It was discussed before that for memory failure handling, we will want
to split huge pages, we will get to it! The trouble is that guest_memfd
took the page from HugeTLB (unlike buddy or HugeTLB which manages memory
from the ground up), so we'll still need to figure out it's okay to let
HugeTLB deal with it when freeing, and when I last looked, HugeTLB
doesn't actually deal with poisoned folios on freeing, so there's more
work to do on the HugeTLB side.

This is a good point, although IIUC it is a separate issue. The need to
split private mappings on memory failure is not for confidentiality in
the TDX sense but to ensure that the guest doesn't use the failed
memory. In that case, contiguity is broken by the failed memory. The
folio is split, the private EPTs are split. The folio size should still
not be checked in TDX code. guest_memfd knows contiguity got broken, so
guest_memfd calls TDX code to split the EPTs.

>
> Yes, I believe splitting private mappings will be invoked to ensure
> that the whole huge folio is not unmapped from KVM due to an error on
> just a 4K page. Is that a problem?
>
> If splitting fails, the implementation can fall back to completely
> zapping the folio range.
>
>> (e.g., after splitting a 1GB folio to 4KB folios with 2MB mappings. Also=
, is it
>> possible for splitting a huge folio to fail partially, without merging t=
he huge
>> folio back or further zapping?).

The current stance is to allow splitting failures and not undo that
splitting failure, so there's no merge back to fix the splitting
failure. (Not set in stone yet, I think merging back could turn out to
be a requirement from the mm side, which comes with more complexity in
restructuring logic.)

If it is not merged back on a split failure, the pages are still
contiguous, the pages are guaranteed contiguous while they are owned by
guest_memfd (even in the case of memory failure, if I get my way :P) so
TDX can still trust that.

I think you're worried that on split failure some folios are split, but
the private EPTs for those are not split, but the memory for those
unsplit private EPTs are still contiguous, and on split failure we quit
early so guest_memfd still tracks the ranges as private.

Privateness and contiguity are preserved so I think TDX should be good
with that? The TD can still run. IIUC it is part of the plan that on
splitting failure, conversion ioctl returns failure, guest is informed
of conversion failure so that it can do whatever it should do to clean
up.

>
> Yes, splitting can fail partially, but guest_memfd will not make the
> ranges available to host userspace and derivatives until:
> 1) The complete range to be converted is split to 4K granularity.
> 2) The complete range to be converted is zapped from KVM EPT mappings.
>
>> Not sure if there're other edge cases we're still missing.
>>

As you said, at the core TDX is concerned about contiguity of the memory
ranges (start_addr, length) that it was given. Contiguity is guaranteed
by guest_memfd while the folio is in guest_memfd ownership up to the
boundaries of the original folio, before any restructuring. So if we're
looking for edge cases, I think they would be around
truncation. Can't think of anything now.

(guest_memfd will also ensure truncation of anything less than the
original size of the folio before restructuring is blocked, regardless
of the current size of the folio)

>> > Separately, KVM could also enforce the folio size/memory contiguity vs
>> > mapping level rule, but TDX code shouldn't enforce KVM's rules. So if
>> > the check is deemed necessary, it still shouldn't be in TDX code, I
>> > think.
>> >
>> > > Pro: Preventing zapping private memory until conversion is successfu=
l is good.
>> > >
>> > > However, could we achieve this benefit in other ways? For example, i=
s it
>> > > possible to ensure hugetlb_restructuring_split_folio() can't fail by=
 ensuring
>> > > split_entries() can't fail (via pre-allocation?) and disabling huget=
lb_vmemmap
>> > > optimization? (hugetlb_vmemmap conversion is super slow according to=
 my
>> > > observation and I always disable it).
>> >
>> > HugeTLB vmemmap optimization gives us 1.6% of memory in savings. For a
>> > huge VM, multiplied by a large number of hosts, this is not a trivial
>> > amount of memory. It's one of the key reasons why we are using HugeTLB
>> > in guest_memfd in the first place, other than to be able to get high
>> > level page table mappings. We want this in production.
>> >
>> > > Or pre-allocation for
>> > > vmemmap_remap_alloc()?
>> > >
>> >
>> > Will investigate if this is possible as mentioned above. Thanks for th=
e
>> > suggestion again!
>> >
>> > > Dropping TDX's sanity check may only serve as our last resort. IMHO,=
 zapping
>> > > private memory before conversion succeeds is still better than intro=
ducing the
>> > > mess between folio size and mapping size.
>> > >
>> > >> > I guess perhaps the question is, is it okay if the folios are sma=
ller
>> > >> > than the mapping while conversion is in progress? Does the order =
matter
>> > >> > (split page table entries first vs split folios first)?
>> > >>
>> > >> Mapping a hugepage for memory that KVM _knows_ is contiguous and ho=
mogenous is
>> > >> conceptually totally fine, i.e. I'm not totally opposed to adding s=
upport for
>> > >> mapping multiple guest_memfd folios with a single hugepage.   As to=
 whether we
>> > >> do (a) nothing, (b) change the refcounting, or (c) add support for =
mapping
>> > >> multiple folios in one page, probably comes down to which option pr=
ovides "good
>> > >> enough" performance without incurring too much complexity.
>> >

