Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1DE2D62F
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 09:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfE2HWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 03:22:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbfE2HWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 03:22:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T7JBsB039577
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:22:01 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssmgnajn6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:22:01 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Wed, 29 May 2019 08:21:58 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 08:21:53 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4T7LqrD48693492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 07:21:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE5FC4C052;
        Wed, 29 May 2019 07:21:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C0104C04E;
        Wed, 29 May 2019 07:21:50 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.8.53])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 29 May 2019 07:21:50 +0000 (GMT)
Date:   Wed, 29 May 2019 10:21:48 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 57/62] x86/mktme: Overview of Multi-Key Total Memory
 Encryption
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-58-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190508144422.13171-58-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19052907-0008-0000-0000-000002EB7A72
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052907-0009-0000-0000-000022584A02
Message-Id: <20190529072148.GE3656@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290049
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:17PM +0300, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Provide an overview of MKTME on Intel Platforms.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  Documentation/x86/mktme/index.rst          |  8 +++
>  Documentation/x86/mktme/mktme_overview.rst | 57 ++++++++++++++++++++++

I'd expect addition of mktme docs to Documentation/x86/index.rst

>  2 files changed, 65 insertions(+)
>  create mode 100644 Documentation/x86/mktme/index.rst
>  create mode 100644 Documentation/x86/mktme/mktme_overview.rst
> 
> diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
> new file mode 100644
> index 000000000000..1614b52dd3e9
> --- /dev/null
> +++ b/Documentation/x86/mktme/index.rst
> @@ -0,0 +1,8 @@
> +
> +=========================================
> +Multi-Key Total Memory Encryption (MKTME)
> +=========================================
> +
> +.. toctree::
> +
> +   mktme_overview
> diff --git a/Documentation/x86/mktme/mktme_overview.rst b/Documentation/x86/mktme/mktme_overview.rst
> new file mode 100644
> index 000000000000..59c023965554
> --- /dev/null
> +++ b/Documentation/x86/mktme/mktme_overview.rst
> @@ -0,0 +1,57 @@
> +Overview
> +=========
> +Multi-Key Total Memory Encryption (MKTME)[1] is a technology that
> +allows transparent memory encryption in upcoming Intel platforms.
> +It uses a new instruction (PCONFIG) for key setup and selects a
> +key for individual pages by repurposing physical address bits in
> +the page tables.
> +
> +Support for MKTME is added to the existing kernel keyring subsystem
> +and via a new mprotect_encrypt() system call that can be used by
> +applications to encrypt anonymous memory with keys obtained from
> +the keyring.
> +
> +This architecture supports encrypting both normal, volatile DRAM
> +and persistent memory.  However, persistent memory support is
> +not included in the Linux kernel implementation at this time.
> +(We anticipate adding that support next.)
> +
> +Hardware Background
> +===================
> +
> +MKTME is built on top of an existing single-key technology called
> +TME.  TME encrypts all system memory using a single key generated
> +by the CPU on every boot of the system. TME provides mitigation
> +against physical attacks, such as physically removing a DIMM or
> +watching memory bus traffic.
> +
> +MKTME enables the use of multiple encryption keys[2], allowing
> +selection of the encryption key per-page using the page tables.
> +Encryption keys are programmed into each memory controller and
> +the same set of keys is available to all entities on the system
> +with access to that memory (all cores, DMA engines, etc...).
> +
> +MKTME inherits many of the mitigations against hardware attacks
> +from TME.  Like TME, MKTME does not mitigate vulnerable or
> +malicious operating systems or virtual machine managers.  MKTME
> +offers additional mitigations when compared to TME.
> +
> +TME and MKTME use the AES encryption algorithm in the AES-XTS
> +mode.  This mode, typically used for block-based storage devices,
> +takes the physical address of the data into account when
> +encrypting each block.  This ensures that the effective key is
> +different for each block of memory. Moving encrypted content
> +across physical address results in garbage on read, mitigating
> +block-relocation attacks.  This property is the reason many of
> +the discussed attacks require control of a shared physical page
> +to be handed from the victim to the attacker.
> +
> +--
> +1. https://software.intel.com/sites/default/files/managed/a5/16/Multi-Key-Total-Memory-Encryption-Spec.pdf
> +2. The MKTME architecture supports up to 16 bits of KeyIDs, so a
> +   maximum of 65535 keys on top of the “TME key” at KeyID-0.  The
> +   first implementation is expected to support 5 bits, making 63
> +   keys available to applications.  However, this is not guaranteed.
> +   The number of available keys could be reduced if, for instance,
> +   additional physical address space is desired over additional
> +   KeyIDs.
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

