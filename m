Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C36F155B92
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgBGQP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:15:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:29440 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgBGQPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 11:15:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 08:15:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="226515846"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2020 08:15:53 -0800
Date:   Fri, 7 Feb 2020 08:15:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200207161553.GE2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
 <20200207153829.GA2401@linux.intel.com>
 <20200207160546.GA707371@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207160546.GA707371@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 11:05:46AM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 07:38:29AM -0800, Sean Christopherson wrote:
> > On Thu, Feb 06, 2020 at 05:12:08PM -0500, Peter Xu wrote:
> > > This patch is tested so I believe this works, however normally I need
> > > to do similar thing with [0] otherwise gcc might complaint.  Is there
> > > any trick behind to make this work?  Or is that because of different
> > > gcc versions?
> > 
> > array[] and array[0] have the same net affect, but array[] is given special
> > treatment by gcc to provide extra sanity checks, e.g. requires the field to
> > be the end of the struct.  Last I checked, gcc also doesn't allow array[]
> > in unions.  There are probably other restrictions.
> > 
> > But, it's precisely because of those restrictions that using array[] is
> > preferred, as it provides extra protections, e.g. if someone moved memslots
> > to the top of the struct it would fail to compile.
> 
> However...
> 
> xz-x1:tmp $ cat a.c
> struct a {
>     int s[];
> };
> 
> int main(void) { }
> xz-x1:tmp $ make a
> cc     a.c   -o a
> a.c:2:9: error: flexible array member in a struct with no named members
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

gcc is telling you quite explicitly why it's angry.  Copy+paste from the
internet[*]:

  Flexible Array Member(FAM) is a feature introduced in the C99 standard of the
  C programming language.

  For the structures in C programming language from C99 standard onwards, we
  can declare an array without a dimension and whose size is flexible in nature.

  Such an array inside the structure should preferably be declared as the last 
  member of structure and its size is variable(can be changed be at runtime).
  
  The structure must contain at least one more named member in addition to the
  flexible array member. 

[*] https://www.geeksforgeeks.org/flexible-array-members-structure-c/

>     2 |     int s[];
>       |         ^
> make: *** [<builtin>: a] Error 1
> 
> My gcc version is 9.2.1 20190827 (Red Hat 9.2.1-1) (GCC).
