Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669091520C6
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 20:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgBDTIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 14:08:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47152 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgBDTIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 14:08:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014J3AmO034485;
        Tue, 4 Feb 2020 19:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KxwhLPw791Y7JGDIyjoxfGholCgicGZEqwQfHrmH2c0=;
 b=j5xCmNhyuRWsgvXQ034hwavRNZAxttnHwwmAn6tzBY78xigcljATAk1snPOxhZc15FvC
 arxpZv8y9kMnFqCtFCD29sVmf7jLNzQrABK4PDmgMx+nQImeqMv1ubMddGdFEm5uF/If
 L1Tvx8w1Moe3xHHUp2HbCHl1STvug0/SqayIuhXbDg/+E9fmBwE7oLKt+GJVjMQVSzzx
 NmcsX830aRe7rOGCxDG/4OUPB5zuFaqHDaAmpcW9lWVULUjvX24qjZgmXDqVvXXQMtHO
 RQuOwY8HSU4/e91gZguCTkjoWFnVProrgKavQKCGG5Lbey5dHqe5H3XXfAge96sw5yOL 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xw19qgtct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:08:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014J4F9A151138;
        Tue, 4 Feb 2020 19:07:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xxvusep28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:07:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 014J7sjI028654;
        Tue, 4 Feb 2020 19:07:54 GMT
Received: from [10.175.207.61] (/10.175.207.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 11:07:54 -0800
Subject: Re: [PATCH RFC 00/10] device-dax: Support devices without PFN
 metadata
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <CAPcyv4g__yY-Gj1S7usijmMXYh8QbD5qtnMhyB27E7UtkK_ffQ@mail.gmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <41b93f9e-aeb8-585d-ff59-53ed59b0b0b7@oracle.com>
Date:   Tue, 4 Feb 2020 19:07:46 +0000
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g__yY-Gj1S7usijmMXYh8QbD5qtnMhyB27E7UtkK_ffQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/20 1:24 AM, Dan Williams wrote:
> On Fri, Jan 10, 2020 at 11:06 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Hey,
> 
> Hi Joao,
> 
>>
>> Presented herewith a small series which allows device-dax to work without
>> struct page to be used to back KVM guests memory. It's an RFC, and there's
>> still some items we're looking at (see TODO below);
> 
> So it turns out I already have some patches in flight that address
> discontiguous allocation item. Here's a WIP branch that I'll be
> sending out after the merge window closes.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending
> 
Neat!

>> but wondering if folks
>> would be OK carving some time out of their busy schedules to provide feedback
>> direction-wise on this work.
> 
> ...apologies I did not get to this sooner. Please feel free to ping me
> after a week if you're awaiting comment on anything in the nvdimm or
> device-dax area.
> 
OK, got it.

>> In virtualized environments (specially those with no kernel-backed PV
>> interfaces, and just SR-IOV), memory is largelly assigned to guests: either
>> persistent with NVDIMMs or volatile for regular RAM. The kernel
>> (hypervisor) tracks it with 'struct page' (64b) for each 4K page. Overall
>> we're spending 16GB for each 1Tb of host memory tracked that the kernel won't
>> need  which could instead be used to create other guests. One of motivations of
>> this series is to then get that memory used for 'struct page', when it is meant
>> to solely be used by userspace.
> 
> Do you mean reclaim it for the guest to use for 'struct page' capacity
> since the host hypervisor has reduced need for it?
> 
Yes.

>> This is also useful for the case of memory
>> backing guests virtual NVDIMMs. The other neat side effect is that the
>> hypervisor has no virtual mapping of the guest and hence code gadgets (if
>> found) are limited in their effectiveness.
> 
> You mean just the direct-map? 

Yes.

> qemu still gets a valid virtual address,
> or are you proposing it's not mapped there either?
> 
Correct, Qemu still has a valid virtual address.

>> It is expected that a smaller (instead of total) amount of host memory is
>> defined for the kernel (with mem=X or memmap=X!Y). For KVM userspace VMM (e.g.
>> QEMU), the main thing that is needed is a device which open + mmap + close with
>> a certain alignment (4K, 2M, 1G). That made us look at device-dax which does
>> just that and so the work comprised here was improving what's there and the
>> interfaces it uses.
> 
> In general I think this "'struct page'-less device-dax" capability
> makes sense, why suffer 1.6% capacity loss when that memory is going
> unused? My main concerns are:

Exactly!

> 
> 1/ Use of memmap=nn!ss when none of the persistent memory
> infrastructure is needed.
> 
> 2/ Auditing the new usage of VM_PFNMAP and what that means for
> memory-error handling and applications that expect 'struct page'
> services to be present.
> 
> 3/ "page-less" dreams have been dashed on the rocks in the past. The
> slow drip of missing features (ptrace(), direct-I/O, fork()...) is why
> the kernel now requires them by default for dax.
> 

wrt to ptrace() the only usage I could find was PEEKDATA/POKEDATA/etc
(essentially access_remote_vm()). Which if devdax defines a access() which
copies back from/to pfn from/to user buffer then it should work. Unless there
something else that I am missing?

> For 1/ I have a proposal, for 2/ I need to dig in to what you have
> here, but maybe I can trade you some review on the discontiguous
> allocation patches.

Will definitely look at those patches. Before this series I actually had started
with hmem (based on your initial work of multi-resource dax) and had patches too
for daxctl (to create/destroy the devices backed with soft reserved memory),
before switching to nd_e820. Let me know where I can help. I can throw those
away and build on top of your work that is on that branch.

For 1), part of the reason to start with memmap= was because the series was more
about devdax infra than the 'partitioning' itself. But it wasn't clear to me
which one would be best fitted layer-wise and given the devdax changes are
somewhat orthogonal then figured I would settle with something simpler that is
reusing a common facility and hear out opinions.

For 2) the idea is to keep the 'struct page' required services usage to the
minimum (or none) necessary. For example, if you have a guest with only VFIO
instances you really don't need much (aside from MCE, and optionally ptrace
attach). For kernel PV, the ones that would require work would be vhost-scsi
which would need the equivalent of (vhost_net.experimental_zcopytx=0 -- default
since v5.3) and therefore copy as opposed to do gup. I have a patch for that.

But as you can see in these patches I am trying to keep the same properties as
existing pte special based mappings. Should we need a 'struct page' I wonder if
we could dynamically create/delete the struct page (e.g. maybe via
find_special_page()).

> For 3/ can you say a bit more about why the
> overhead is intolerable?
> 

It really is about extra memory 'wasted' when the hypervisor purpose is to
service back those same resources (e.g. memory, IO) to guests.

In terms of percentage it's somewhat reductory when we use 1.6% as overhead (or
16GB per Tb). When we take into account that most of hypervisor applications
required memory should be kept small[*], then you quickly realize those 'lost'
16Gb consumed for 'struct page' is a lot. The hugepages (which you also get with
dexdax with a devmap) also help further as you deterministically require less
memory for page table entries.

[*] as an arbritary example: say only only up to 18Gb or less for hypervisor
applications/orchestration in a 1Tb machine.

This is also orthogonal to volatile RAM; I suppose we have the same problem in
persistent memory which is also given to guests via say e.g. Qemu emulated NVDIMMs.

> The proposal for 1/ is please let's not build more on top of
> memmap=nn!ss. It's fragile because there's no facility to validate
> that it is correct, the assumption is that the user overriding the
> memmap knows to pick address that don't collide and have real memory
> backing. Practice has shown that people get it wrong often enough that
> we need something better. 

/nods Agreed.

> It's also confusing that applications start
> seeing "Persistent Memory" in /proc/iomem when it's only there to
> shunt memory over to device-dax.
> 

Right. The one side benefit of existing nvdimm's facilities though is that we
reuse namespace-based partitioning, and so this split of dax sort of ends up
replicating what's already in drivers/nvdimm. But I am not arguing one way or
another; as atm I was already wondering if I am abusing nvdimm or whether this
new layer would be created.

> The alternative is "efi_fake_mem=nn@ss:0x40000" and the related
> 'soft-reservation' enabling that bypasses the persistent memory
> enabling and assigns memory to device-dax directly. EFI attribute
> override is safer because this attribute is only honored when applied
> to existing EFI conventional memory.
> 
/nods

One idea I had was to make this slightly more dynamic as opposed to a hard limit
; and it would be less tied in to the EFI memory map.

Say we would offline certain memory blocks and reassign them back to dax_hmem.
In a way it would be somewhat the reserve of dax_kmem (or rather dax_kmem
understanding of new_id with memory%d devices). Would that be sensible? I am
still sketching this, not yet sure on the extent that I get it cleanly.

> Have a look at that branch just be warned it's not polished, or just
> wait for me to send them out with a proper cover letter, and I'll take
> a look at what you have below.
> 
Cool, awesome.


>>
>> The series is divided as follows:
>>
>>  * Patch 1 , 3: Preparatory work for patch 7 for adding support for
>>                vmf_insert_{pmd,pud} with dax pfn flags PFN_DEV|PFN_SPECIAL
>>
>>  * Patch 2 , 4: Preparatory work for patch 7 for adding support for
>>                follow_pfn() to work with 2M/1G huge pages, which is
>>                what KVM uses for VM_PFNMAP.
>>
>>  * Patch 5 - 7: One bugfix and device-dax support for PFN_DEV|PFN_SPECIAL,
>>                which encompasses mainly dealing with the lack of devmap,
>>                and creating a VM_PFNMAP vma.
>>
>>  * Patch 8: PMEM support for no PFN metadata only for device-dax namespaces.
>>            At the very end of the cover letter (after scissors mark),
>>            there's a patch for ndctl to be able to create namespaces
>>            with '--mode devdax --map none'.
>>
>>  * Patch 9: Let VFIO handle VM_PFNMAP without relying on vm_pgoff being
>>             a PFN.
>>
>>  * Patch 10: The actual end consumer example for RAM case. The patch just adds a
>>              label storage area which consequently allows namespaces to be
>>              created. We picked PMEM legacy for starters.
>>
>> Thoughts, coments appreciated.
>>         Joao
>>
>> P.S. As an example to try this out:
>>
>>  1) add 'memmap=48G!16G' to the kernel command line, on a host with 64G,
>>  and kernel has 16G.
>>
>>  2) create a devdax namespace with 1G hugepages:
>>
>>  $ ndctl create-namespace --verbose --mode devdax --map none --size 32G --align 1G -r 0
>>  {
>>   "dev":"namespace0.0",
>>   "mode":"devdax",
>>   "map":"none",
>>   "size":"32.00 GiB (34.36 GB)",
>>   "uuid":"dfdd05cd-2611-46ac-8bcd-10b6194f32d4",
>>   "daxregion":{
>>     "id":0,
>>     "size":"32.00 GiB (34.36 GB)",
>>     "align":1073741824,
>>     "devices":[
>>       {
>>         "chardev":"dax0.0",
>>         "size":"32.00 GiB (34.36 GB)",
>>         "target_node":0,
>>         "mode":"devdax"
>>       }
>>     ]
>>   },
>>   "align":1073741824
>>  }
>>
>>  3) Add this to your qemu params:
>>   -m 32G
>>   -object memory-backend-file,id=mem,size=32G,mem-path=/dev/dax0.0,share=on,align=1G
>>   -numa node,memdev=mem
>>
>> TODO:
>>
>>  * Discontiguous regions/namespaces: The work above is limited to max
>> contiguous extent, coming from nvdimm dpa allocation heuristics -- which I take
>> is because of what specs allow for persistent namespaces. But for volatile RAM
>> case we would need handling of discontiguous extents (hence a region would represent
>> more than a resource) to be less bound to how guests are placed on the system.
>> I played around with multi-resource for device-dax, but I'm wondering about
>> UABI: 1) whether nvdimm DPA allocation heuristics should be relaxed for RAM
>> case (under certain nvdimm region bits); or if 2) device-dax would have it's
>> own separate UABI to be used by daxctl (which would be also useful for hmem
>> devices?).
>>

Btw one thing I couldn't tell from specs is whether a persistent namespace is
allowed to be represented with 2 or more discontiguous resources. I know of
block mode namespaces, but I am not sure it is eligible to represent a
'discontiguous' persistent namespace be represented like block-mode namespace
labels despite not having any btt interface. That seemed to work so far (but I
am not testing on an actual NVDIMM); but given we would pursue towards the hmem
approach this is also less relevant.

>>  * MCE handling: For contiguous regions vm_pgoff could be set to the pfn in
>> device-dax, which would allow collect_procs() to find the processes solely based
>> on the PFN. But for discontiguous namespaces, not sure if this would work; perhaps
>> looking at the dax-region pfn range for each DAX vma.
> 
> You mean, make the memory error handling device-dax aware?
> 

/nods

The reason being that with discontinuous regions the assumption of 'vma PFN =
vm_pgoff + (addr - vm_start)' would no longer be sufficient to determine whether
a vma with PFNMAP has the PFN that triggered the MCE. So far I am having a vma
vm operation which finds the address for a given PFN; (essentially the reverse
of a follow_pfn()). Given that devdax knows which pfns it fills in it would be
cheap. Then memory failure SIGBUS the found process, which then (VMM) does a
vMCE to the guest. Guest then recovers the way it sees fit. This is not in this
series but I was hoping to include on v2.

>>
>>  * NUMA: For now excluded setting the target_node; while these two patches
>>  are being worked on[1][2].
>>
>>  [1] https://lore.kernel.org/lkml/157401276776.43284.12396353118982684546.stgit@dwillia2-desk3.amr.corp.intel.com/
>>  [2] https://lore.kernel.org/lkml/157401277293.43284.3805106435228534675.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> I'll ping x86 folks again after the merge window. I expect they have
> just not had time to ack them yet.
> 
Cool, Thanks for the feedback so far!

	Joao
