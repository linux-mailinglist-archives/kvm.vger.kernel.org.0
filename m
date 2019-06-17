Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6824944C
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 23:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbfFQVg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 17:36:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:46139 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727366AbfFQVg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 17:36:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 14:36:55 -0700
X-ExtLoop1: 1
Received: from ray.jf.intel.com (HELO [10.7.201.126]) ([10.7.201.126])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 14:36:54 -0700
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for
 MKTME
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
 <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
 <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
 <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dave.hansen@intel.com; keydata=
 mQINBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABtEVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT6JAjgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lcuQINBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABiQIfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
Message-ID: <d599b1d7-9455-3012-0115-96ddbad31833@intel.com>
Date:   Mon, 17 Jun 2019 14:36:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Where if we have something like mprotect() (or madvise() or something
>> else taking pointer), we can just do:
>>
>>         fd = open("/dev/anything987");
>>         ptr = mmap(fd);
>>         sys_encrypt(ptr);
> 
> I'm having a hard time imagining that ever working -- wouldn't it blow
> up if someone did:
> 
> fd = open("/dev/anything987");
> ptr1 = mmap(fd);
> ptr2 = mmap(fd);
> sys_encrypt(ptr1);
> 
> So I think it really has to be:
> fd = open("/dev/anything987");
> ioctl(fd, ENCRYPT_ME);
> mmap(fd);

Yeah, shared mappings are annoying. :)

But, let's face it, nobody is going to do what you suggest in the
ptr1/ptr2 example.  It doesn't make any logical sense because it's
effectively asking to read the memory with two different keys.  I
_believe_ fscrypt has similar issues and just punts on them by saying
"don't do that".

We can also quite easily figure out what's going on.  It's a very simple
rule to kill a process that tries to fault a page in whose KeyID doesn't
match the VMA under which it is faulted in, and also require that no
pages are faulted in under VMAs which have their key changed.


>> Now, we might not *do* it that way for dax, for instance, but I'm just
>> saying that if we go the /dev/mktme route, we never get a choice.
>>
>>> I think that, in the long run, we're going to have to either expand
>>> the core mm's concept of what "memory" is or just have a whole
>>> parallel set of mechanisms for memory that doesn't work like memory.
>> ...
>>> I expect that some day normal memory will  be able to be repurposed as
>>> SGX pages on the fly, and that will also look a lot more like SEV or
>>> XPFO than like the this model of MKTME.
>>
>> I think you're drawing the line at pages where the kernel can manage
>> contents vs. not manage contents.  I'm not sure that's the right
>> distinction to make, though.  The thing that is important is whether the
>> kernel can manage the lifetime and location of the data in the page.
> 
> The kernel can manage the location of EPC pages, for example, but only
> under extreme constraints right now.  The draft SGX driver can and
> does swap them out and swap them back in, potentially at a different
> address.

The kernel can't put arbitrary data in EPC pages and can't use normal
memory for EPC.  To me, that puts them clearly on the side of being
unmanageable by the core mm code.

For instance, there's no way we could mix EPC pages in the same 'struct
zone' with non-EPC pages.  Not only are they not in the direct map, but
they never *can* be, even for a second.

>>> And, one of these days, someone will come up with a version of XPFO
>>> that could actually be upstreamed, and it seems entirely plausible
>>> that it will be totally incompatible with MKTME-as-anonymous-memory
>>> and that users of MKTME will actually get *worse* security.
>>
>> I'm not following here.  XPFO just means that we don't keep the direct
>> map around all the time for all memory.  If XPFO and
>> MKTME-as-anonymous-memory were both in play, I think we'd just be
>> creating/destroying the MKTME-enlightened direct map instead of a
>> vanilla one.
> 
> What I'm saying is that I can imagine XPFO also wanting to be
> something other than anonymous memory.  I don't think we'll ever want
> regular MAP_ANONYMOUS to enable XPFO by default because the
> performance will suck.

It will certainly suck for some things.  But, does it suck if the kernel
never uses the direct map for the XPFO memory?  If it were for KVM guest
memory for a guest using direct device assignment, we might not even
ever notice.

> I'm thinking that XPFO is a *lot* simpler under the hood if we just
> straight-up don't support GUP on it.  Maybe we should call this
> "strong XPFO".  Similarly, the kinds of things that want MKTME may
> also want the memory to be entirely absent from the direct map.  And
> the things that use SEV (as I understand it) *can't* usefully use the
> memory for normal IO via GUP or copy_to/from_user(), so these things
> all have a decent amount in common.

OK, so basically, you're thinking about new memory management
infrastructure that a memory-allocating-app can opt into where they get
a reduced kernel feature set, but also increased security guarantees?
 The main insight thought is that some hardware features *already*
impose (some of) this reduced feature set?

FWIW, I don't think many folks will go for the no-GUP rule.  It's one
thing to say no-GUPs for SGX pages which can't have I/O done on them in
the first place, but it's quite another to tell folks that sendfile() no
longer works without bounce buffers.

MKTME's security guarantees are very different than something like SEV.
 Since the kernel is in the trust boundary, it *can* do fun stuff like
RDMA which is a heck of a lot faster than bounce buffering.  Let's say a
franken-system existed with SEV and MKTME.  It isn't even clear to me
that *everyone* would pick SEV over MKTME.  IOW, I'm not sure the MKTME
model necessarily goes away given the presence of SEV.

> And another silly argument: if we had /dev/mktme, then we could
> possibly get away with avoiding all the keyring stuff entirely.
> Instead, you open /dev/mktme and you get your own key under the hook.
> If you want two keys, you open /dev/mktme twice.  If you want some
> other program to be able to see your memory, you pass it the fd.

We still like the keyring because it's one-stop-shopping as the place
that *owns* the hardware KeyID slots.  Those are global resources and
scream for a single global place to allocate and manage them.  The
hardware slots also need to be shared between any anonymous and
file-based users, no matter what the APIs for the anonymous side.
