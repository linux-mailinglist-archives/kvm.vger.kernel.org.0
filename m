Return-Path: <kvm+bounces-67578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF7EAD0B297
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F39F93047D90
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 16:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E7C35F8CF;
	Fri,  9 Jan 2026 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nTEkoEjg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD67225408
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 16:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975183; cv=pass; b=m+Xfg6LY6oTi8hIfB8BCrDOWjKIn2Pvl77vboMW5PkC1LaoH9qsyaCglYr0nS1kOBQOlHUr7zizWUztBlHfEXQmfz1naCXxoOlnBNyod45xL4UHXcIRCqWmfQUGjqk0NTS4C+diz4aPgHojmjER0xRb5w3onNijTij6arcjAh/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975183; c=relaxed/simple;
	bh=bLCHmSm5P+0OYStZfCcGo7GAoaTHIeV4ZV4G2JhHh58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9RuLRVlVfyTP4+ZqSZYd30cWdTLJoNYPw2W1K9n1Z6fYhA39pEKnmfDgUlPQ3OsYjkxHzZ7sRGI2nl++Q5uYAxC+HESmKP+qIu5ZBk8IRi/nDErjkNFhMUalz+dDZjzR0KZswAEitmblXnhMCWL+O74hqfa2Y0IrXk1jpt/vCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nTEkoEjg; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-121adc0f1e5so9030c88.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 08:13:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767975180; cv=none;
        d=google.com; s=arc-20240605;
        b=hlNnLdfsLTKg4HzvV9QsRpmep4UopjLAY/MiK8+0u/QMchDPolyX8NivsyQMs+X0VT
         4fjBlJeEdmHahd20M+yyiNtZLbtC+FtfSMm5HOw6U10Vz8VYBirvT3neH4JjHMG9sncQ
         1+oJBs8h78v8BgNNQgpu+R4m+4sGvHCUFSDwOhnn/OrXYqAQ0rtk5ZXkaTsOygZIpbtf
         N9iaPeo1Hrxmey4DjN3Cbosi2fDnbUMXTvne0ShTjcQHnpFfpDdCQZh1OsNRbCzBPymE
         zn6uZhgGmiZ59HBHpLDj64yiHMQRG684GGXjQNNJSohaAouSx/zjeLHvXMbB5FGueMgJ
         j+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GrqA3i0ohUrb8LdYy6zMEbvfi20VZFb3GSF+Vj5Msrw=;
        fh=rMVvW5gCvXKLZcw8KB+/uWamz/YXokBx0CP86fabMQg=;
        b=CNn4MnDdENc6j78pI8m9umns6eT3S6IScqusc7uDBfnaMXch50Z5u8CGVe11eRP74K
         m2wnvR9HJSZIu43USRV29B8fSDfuwavcCCcDC/zAMio+TXkgnSMtDk/QssaTkQdU9rf8
         zrIxZsUMsF1XyKwV//bKclEOmcD3cAEk7x01xk//7At0+inPHxfaFJdlAsr3EZwwt2s1
         U2vJfkGdhDV1HlF9JrWhTFSkEy/iEltCUgu8Y7QM96gAhBB/AvnrZk7z4t/wW05xpqYw
         tLskcCQo3d+8e2+lmR5mu8m5R/GQ6LtglSCunmUs1Qz45P5oVnsjioEDtAxGIh38LpeZ
         yJYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767975180; x=1768579980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrqA3i0ohUrb8LdYy6zMEbvfi20VZFb3GSF+Vj5Msrw=;
        b=nTEkoEjggMe7NCKeJNkC5l5kQE8yaFvYBcgHnvXY5yg84CAMmHDU4L6hoJBmUE9je4
         t5WkKKiLfrZbRS6951KxuuC5LaBGXaAbue/qzvwxlaM7MtvMrDsZqmXiAzQPo4j5qJCr
         hu65M8G9ZtqCGYxykhP1YtcB0WIg5aNNBIPMb+pGL2Zih365ZwzjfF2VBEvvjqWONEWv
         bueKvqfL/z6VVj5PGQMJ7pbJJBnzADYk8zk00pQps/s1IKSh7y1pI5XWBzN2llJfiDSX
         CiiRpAHkVCR1zHV3P8af0JIzoUZjF9bLJ925M9+i2QTka4Cu7ATd3Gebi5nOGezoNMGh
         ES2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767975180; x=1768579980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GrqA3i0ohUrb8LdYy6zMEbvfi20VZFb3GSF+Vj5Msrw=;
        b=vvBZGENQbnSn6UFsc/6ETCnwROeexG4um/sjMzGN18JWwmpwwajgUU2HEUJYFUakQT
         xW0SYICm9t0pI77dm7IANwlIcn0Cg7wFVfGhtZnWrUA/wdRKyU0ZFRh0TKw5K1WUuP8R
         Y8x75hnNxbq++/zJ6PqxeN4FkJWH8+8P9XPOnbxZBPjlS/UWhxwGO5Tm3CIosMrmyN65
         KeTDDNT2iZtWDF0pJMGqunMJP4Qk6z/QCNovDz79Png7QgZFLF49rR2b2CQvzJ1xvebC
         35qvljyPwebMuM4Mm0MTVbW71loOh5AqInv+qV3NO4KqN3g5zVzyQ1XXhrscW4PcMBJr
         KQEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV52wYdG3N+Qo2ko/XSB1Xq6FwCCUlsGuqFPoTkV+JeVveueC3laA0suGc8QTfdyggUaGc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf5sxMqAC7ipZzOVBnSKFpBH945XRgwpuFj7txmCV/wXfi6nMv
	Mb5oVL7hZaYbf56Rs9+uT67bLqN7YAZxDnI+FBYL8v3l3Fkd0oYakkxPoMCrfloyQS+4kwHAABI
	x453M3BXMOV4fr1elJp5RhRie+DOkHNHUB6QkKPnL
X-Gm-Gg: AY/fxX4XmzeuHUO8z9BobRRABEETiy4WROfLDHYgkec8r8Tsyo9REocPgvQvCGtBw0i
	R/ziaQxHiMNfP3L02fbBv1wlegwGki3UV6qKgoZ4JhLBEQQhdQ10tj1W0APsCeT1U1aaO7tCT8j
	Y0IoDd1C5phFtwTbUdpFaL2OtSKrnhtPX22vaZzcu7zDNu7+ZUbOKzV1n6MQkHMPSR02pSRJQXp
	g3cGKj9uEYpv+kS3BlUKdRYmxdKJYpmju/BiqCWPgxkF/9fYXPWXKr/JiBQcqhCeyt55mrCSPtK
	O0MGsm5rmtzzNcKjFOdMFcoxBMgsUawLR84koz0=
X-Received: by 2002:a05:7022:f98:b0:119:e56b:c1e1 with SMTP id
 a92af1059eb24-122053d4e27mr115364c88.12.1767975179315; Fri, 09 Jan 2026
 08:12:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com> <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
In-Reply-To: <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 9 Jan 2026 08:12:46 -0800
X-Gm-Features: AQt7F2oS6tPqkHf6IEC575wkWY1Z77ICqz6UaGLkPOBs3agORZO8T31RRJMs0U4
Message-ID: <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 9, 2026 at 1:21=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Thu, Jan 08, 2026 at 12:11:14PM -0800, Ackerley Tng wrote:
> > Yan Zhao <yan.y.zhao@intel.com> writes:
> >
> > > On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
> > >> On Tue, Jan 06, 2026, Ackerley Tng wrote:
> > >> > Sean Christopherson <seanjc@google.com> writes:
> > >> >
> > >> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
> > >> > >> Vishal Annapurve <vannapurve@google.com> writes:
> > >> > >>
> > >> > >> > On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@i=
ntel.com> wrote:
> > >> > >> >>
> > >> > >> >> - EPT mapping size and folio size
> > >> > >> >>
> > >> > >> >>   This series is built upon the rule in KVM that the mapping=
 size in the
> > >> > >> >>   KVM-managed secondary MMU is no larger than the backend fo=
lio size.
> > >> > >> >>
> > >> > >>
> > >> > >> I'm not familiar with this rule and would like to find out more=
. Why is
> > >> > >> this rule imposed?
> > >> > >
> > >> > > Because it's the only sane way to safely map memory into the gue=
st? :-D
> > >> > >
> > >> > >> Is this rule there just because traditionally folio sizes also =
define the
> > >> > >> limit of contiguity, and so the mapping size must not be greate=
r than folio
> > >> > >> size in case the block of memory represented by the folio is no=
t contiguous?
> > >> > >
> > >> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping si=
ze was (and still
> > >> > > is) strictly bound by the host mapping size.  That's handles con=
tiguous addresses,
> > >> > > but it _also_ handles contiguous protections (e.g. RWX) and othe=
r attributes.
> > >> > >
> > >> > >> In guest_memfd's case, even if the folio is split (just for ref=
count
> > >> > >> tracking purposese on private to shared conversion), the memory=
 is still
> > >> > >> contiguous up to the original folio's size. Will the contiguity=
 address
> > >> > >> the concerns?
> > >> > >
> > >> > > Not really?  Why would the folio be split if the memory _and its=
 attributes_ are
> > >> > > fully contiguous?  If the attributes are mixed, KVM must not cre=
ate a mapping
> > >> > > spanning mixed ranges, i.e. with multiple folios.
> > >> >
> > >> > The folio can be split if any (or all) of the pages in a huge page=
 range
> > >> > are shared (in the CoCo sense). So in a 1G block of memory, even i=
f the
> > >> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
> > >> > would be split, and the split folios are necessary for tracking us=
ers of
> > >> > shared pages using struct page refcounts.
> > >>
> > >> Ahh, that's what the refcounting was referring to.  Gotcha.
> > >>
> > >> > However the split folios in that 1G range are still fully contiguo=
us.
> > >> >
> > >> > The process of conversion will split the EPT entries soon after th=
e
> > >> > folios are split so the rule remains upheld.
> >
> > Correction here: If we go with splitting from 1G to 4K uniformly on
> > sharing, only the EPT entries around the shared 4K folio will have thei=
r
> > page table entries split, so many of the EPT entries will be at 2M leve=
l
> > though the folios are 4K sized. This would be last beyond the conversio=
n
> > process.
> >
> > > Overall, I don't think allowing folios smaller than the mappings whil=
e
> > > conversion is in progress brings enough benefit.
> > >
> >
> > I'll look into making the restructuring process always succeed, but off
> > the top of my head that's hard because
> >
> > 1. HugeTLB Vmemmap Optimization code would have to be refactored to
> >    use pre-allocated pages, which is refactoring deep in HugeTLB code
> >
> > 2. If we want to split non-uniformly such that only the folios that are
> >    shared are 4K, and the remaining folios are as large as possible (PM=
D
> >    sized as much as possible), it gets complex to figure out how many
> >    pages to allocate ahead of time.
> >
> > So it's complex and will probably delay HugeTLB+conversion support even
> > more!
> >
> > > Cons:
> > > (1) TDX's zapping callback has no idea whether the zapping is caused =
by an
> > >     in-progress private-to-shared conversion or other reasons. It als=
o has no
> > >     idea if the attributes of the underlying folios remain unchanged =
during an
> > >     in-progress private-to-shared conversion. Even if the assertion A=
ckerley
> > >     mentioned is true, it's not easy to drop the sanity checks in TDX=
's zapping
> > >     callback for in-progress private-to-shared conversion alone (whic=
h would
> > >     increase TDX's dependency on guest_memfd's specific implementatio=
n even if
> > >     it's feasible).
> > >
> > >     Removing the sanity checks entirely in TDX's zapping callback is =
confusing
> > >     and would show a bad/false expectation from KVM -- what if a huge=
 folio is
> > >     incorrectly split while it's still mapped in KVM (by a buggy gues=
t_memfd or
> > >     others) in other conditions? And then do we still need the check =
in TDX's
> > >     mapping callback? If not, does it mean TDX huge pages can stop re=
lying on
> > >     guest_memfd's ability to allocate huge folios, as KVM could still=
 create
> > >     huge mappings as long as small folios are physically contiguous w=
ith
> > >     homogeneous memory attributes?
> > >
> > > (2) Allowing folios smaller than the mapping would require splitting =
S-EPT in
> > >     kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may argu=
e that the
> > >     invalidate lock held in __kvm_gmem_set_attributes() could guard a=
gainst
> > >     concurrent kvm_gmem_error_folio(), it still doesn't seem clean an=
d looks
> > >     error-prone. (This may also apply to kvm_gmem_migrate_folio() pot=
entially).
> > >
> >
> > I think the central question I have among all the above is what TDX
> > needs to actually care about (putting aside what KVM's folio size/memor=
y
> > contiguity vs mapping level rule for a while).
> >
> > I think TDX code can check what it cares about (if required to aid
> > debugging, as Dave suggested). Does TDX actually care about folio sizes=
,
> > or does it actually care about memory contiguity and alignment?
> TDX cares about memory contiguity. A single folio ensures memory contigui=
ty.

In this slightly unusual case, I think the guarantee needed here is
that as long as a range is mapped into SEPT entries, guest_memfd
ensures that the complete range stays private.

i.e. I think it should be safe to rely on guest_memfd here,
irrespective of the folio sizes:
1) KVM TDX stack should be able to reclaim the complete range when unmappin=
g.
2) KVM TDX stack can assume that as long as memory is mapped in SEPT
entries, guest_memfd will not let host userspace mappings to access
guest private memory.

>
> Allowing one S-EPT mapping to cover multiple folios may also mean it's no=
 longer
> reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
> contiguous range larger than the page's folio range.

What's the issue with passing the (struct page*, unsigned long nr_pages) pa=
ir?

>
> Additionally, we don't split private mappings in kvm_gmem_error_folio().
> If smaller folios are allowed, splitting private mapping is required ther=
e.

Yes, I believe splitting private mappings will be invoked to ensure
that the whole huge folio is not unmapped from KVM due to an error on
just a 4K page. Is that a problem?

If splitting fails, the implementation can fall back to completely
zapping the folio range.

> (e.g., after splitting a 1GB folio to 4KB folios with 2MB mappings. Also,=
 is it
> possible for splitting a huge folio to fail partially, without merging th=
e huge
> folio back or further zapping?).

Yes, splitting can fail partially, but guest_memfd will not make the
ranges available to host userspace and derivatives until:
1) The complete range to be converted is split to 4K granularity.
2) The complete range to be converted is zapped from KVM EPT mappings.

> Not sure if there're other edge cases we're still missing.
>
> > Separately, KVM could also enforce the folio size/memory contiguity vs
> > mapping level rule, but TDX code shouldn't enforce KVM's rules. So if
> > the check is deemed necessary, it still shouldn't be in TDX code, I
> > think.
> >
> > > Pro: Preventing zapping private memory until conversion is successful=
 is good.
> > >
> > > However, could we achieve this benefit in other ways? For example, is=
 it
> > > possible to ensure hugetlb_restructuring_split_folio() can't fail by =
ensuring
> > > split_entries() can't fail (via pre-allocation?) and disabling hugetl=
b_vmemmap
> > > optimization? (hugetlb_vmemmap conversion is super slow according to =
my
> > > observation and I always disable it).
> >
> > HugeTLB vmemmap optimization gives us 1.6% of memory in savings. For a
> > huge VM, multiplied by a large number of hosts, this is not a trivial
> > amount of memory. It's one of the key reasons why we are using HugeTLB
> > in guest_memfd in the first place, other than to be able to get high
> > level page table mappings. We want this in production.
> >
> > > Or pre-allocation for
> > > vmemmap_remap_alloc()?
> > >
> >
> > Will investigate if this is possible as mentioned above. Thanks for the
> > suggestion again!
> >
> > > Dropping TDX's sanity check may only serve as our last resort. IMHO, =
zapping
> > > private memory before conversion succeeds is still better than introd=
ucing the
> > > mess between folio size and mapping size.
> > >
> > >> > I guess perhaps the question is, is it okay if the folios are smal=
ler
> > >> > than the mapping while conversion is in progress? Does the order m=
atter
> > >> > (split page table entries first vs split folios first)?
> > >>
> > >> Mapping a hugepage for memory that KVM _knows_ is contiguous and hom=
ogenous is
> > >> conceptually totally fine, i.e. I'm not totally opposed to adding su=
pport for
> > >> mapping multiple guest_memfd folios with a single hugepage.   As to =
whether we
> > >> do (a) nothing, (b) change the refcounting, or (c) add support for m=
apping
> > >> multiple folios in one page, probably comes down to which option pro=
vides "good
> > >> enough" performance without incurring too much complexity.
> >

