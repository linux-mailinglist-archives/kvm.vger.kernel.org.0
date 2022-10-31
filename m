Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0DA612F77
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 05:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJaEXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 00:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJaEXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 00:23:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0347672;
        Sun, 30 Oct 2022 21:23:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o7so6184648pjj.1;
        Sun, 30 Oct 2022 21:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vH+u5Bvhhpd8c/WXOrPFjzMFEIOOOR91w47tMe67fvw=;
        b=ZoF5wNrDtCndMrY5l1x5eCa5Xf6dlwImcvus3j/fwWhwYcSyeTw2p7+vl0mPJFVHRe
         T/GUttK1LxvwUA36ZnzZRiWUikvAAouXVxoTHzHMHNVNz7M4CWKj7yBCV4kPmaLhDGX+
         69g8BWNd99uZFqNXprg/s9UlKStqMT9L4/9dp9A7CZro6WecWVzQ3tjxKUHSAhGRVvfD
         p2hah64j20nuGgkUFxaFnJlyDCERKaTbxF63gH98ngLiZYVVRxtG09zrYBBM8WFSOZdc
         gUc0R/h5GhaV2QxKKGEh1gpc+O5r/cio8EWw/m8ARt7EMJi9AhEfuTDZnRrOZigbdJCK
         COuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vH+u5Bvhhpd8c/WXOrPFjzMFEIOOOR91w47tMe67fvw=;
        b=ii2xctD3goGdu4pRega59iAjyS9//PU//sOuIC4+Odnkp1Ytsj1UkGtDXl+v+xxDNy
         ZIWTMuV2bu1ifzVL+8x3fwl5xhv86VOSy3opJq3d4JqNsINZ5qowUAqdZ0uHuZ4em2Of
         vMwli1yKRknf82wwy3kWtNc/Y8J/+IFGPzk4iL3ujmvWcq2B4/m1gSacm4/WScKsE8x1
         hoNYXIcxuBiI/LCtyJV46eYYptEhZxNjBaBM9g6qilA8HKHvVxghrSv/kyf/9v3xPvZX
         xW7dqzBMhGNqJAOcx05KzA736W4/W/PL6s8i4WfGAtO+INAC7Z40XwJVl0h9h9Ok1JlJ
         2h2A==
X-Gm-Message-State: ACrzQf0799WNNDeBBz7VNEHrIpH9BHE+BOeq4fpboLUT2KpuMSpF4HPj
        JmzjpiyetR6TkHsSdq6EyhQ=
X-Google-Smtp-Source: AMsMyM7a+6pY9T+TrDG5O6IqlyTrShqEWuaBbhnkaJwUAEgEAUgldq0Ai1cKfy2rTHswY3+NdoG19Q==
X-Received: by 2002:a17:90b:17c9:b0:213:32a9:465b with SMTP id me9-20020a17090b17c900b0021332a9465bmr12627095pjb.54.1667190227666;
        Sun, 30 Oct 2022 21:23:47 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-72.three.co.id. [223.255.225.72])
        by smtp.gmail.com with ESMTPSA id u29-20020a63455d000000b0046faefad8a1sm1671086pgk.79.2022.10.30.21.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 21:23:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C9A6F100398; Mon, 31 Oct 2022 11:23:42 +0700 (WIB)
Date:   Mon, 31 Oct 2022 11:23:42 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 107/108] KVM: x86: design documentation on TDX
 support of x86 KVM TDP MMU
Message-ID: <Y19NzlQcwhV/2wl3@debian.me>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <91062ba1b723d5b866b17447e3f8f8addaa334ee.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Aew40JBmWCIbpsgg"
Content-Disposition: inline
In-Reply-To: <91062ba1b723d5b866b17447e3f8f8addaa334ee.1667110240.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Aew40JBmWCIbpsgg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 29, 2022 at 11:23:48PM -0700, isaku.yamahata@intel.com wrote:
> +During TDX non-root operation (i.e. guest TD), memory accesses can be qu=
alified
> +as either shared or private, based on the value of a new SHARED bit in t=
he Guest
> +Physical Address (GPA).  The CPU translates shared GPAs using the usual =
VMX EPT
> +(Extended Page Table) or "Shared EPT" (in this document), which resides =
in the
> +host VMM memory.  The Shared EPT is directly managed by the host VMM - t=
he same
> +as with the current VMX.  Since guest TDs usually require I/O, and the d=
ata
> +exchange needs to be done via shared memory, thus KVM needs to use the c=
urrent
> +EPT functionality even for TDs.

Strip the last "thus", so it becomes "... via shared memory, KVM needs to u=
se ..."

> +The following depicts the relationship.
> +::
> +
> +                    KVM                             |       TDX module
> +                     |                              |           |
> +        -------------+----------                    |           |
> +        |                      |                    |           |
> +        V                      V                    |           |
> +     shared GPA           private GPA               |           |
> +  CPU shared EPT pointer  KVM private EPT pointer   |  CPU secure EPT po=
inter
> +        |                      |                    |           |
> +        |                      |                    |           |
> +        V                      V                    |           V
> +  shared EPT                private EPT<-------mirror----->Secure EPT
> +        |                      |                    |           |
> +        |                      \--------------------+------\    |
> +        |                                           |      |    |
> +        V                                           |      V    V
> +  shared guest page                                 |    private guest p=
age
> +                                                    |
> +                                                    |
> +                              non-encrypted memory  |    encrypted memory
> +                                                    |
> +
> +shared EPT: CPU and KVM walk with shared GPA
> +            Maintained by the existing code
> +private EPT: KVM walks with private GPA
> +             Maintained by the twisted existing code
> +secure EPT: CPU walks with private GPA.
> +            Maintained by TDX module with TDX SEAMCALLs via hooks
> +

What about this legend below?

---- >8 ----

diff --git a/Documentation/virt/kvm/tdx-tdp-mmu.rst b/Documentation/virt/kv=
m/tdx-tdp-mmu.rst
index 2d91c94e6d8fd7..9ddbf44725f212 100644
--- a/Documentation/virt/kvm/tdx-tdp-mmu.rst
+++ b/Documentation/virt/kvm/tdx-tdp-mmu.rst
@@ -236,12 +236,14 @@ The following depicts the relationship.
                               non-encrypted memory  |    encrypted memory
                                                     |
=20
-shared EPT: CPU and KVM walk with shared GPA
-            Maintained by the existing code
-private EPT: KVM walks with private GPA
-             Maintained by the twisted existing code
-secure EPT: CPU walks with private GPA.
-            Maintained by TDX module with TDX SEAMCALLs via hooks
+Where:
+
+  * shared EPT: CPU and KVM walk with shared GPA (maintained by the existi=
ng
+    code)
+  * private EPT: KVM walks with private GPA (maintained by the twisted exi=
sting
+    code)
+  * secure EPT: CPU walks with private GPA (maintained by TDX module with =
TDX
+    SEAMCALLs via hooks).
=20
=20
 Tracking private EPT page

> +Concurrent zapping
> +------------------
> +1. read lock
> +2. freeze the EPT entry (atomically set the value to REMOVED_SPTE)
> +   If other vcpu froze the entry, restart page fault.
> +3. TLB shootdown
> +
> +   * send IPI to remote vcpus
> +   * TLB flush (local and remote)
> +
> +   For each entry update, TLB shootdown is needed because of the
> +   concurrency.

Concurrency issues?

Also, as I have iterated several times before, you need to add the
documentation to KVM table of contents (index):

---- >8 ----

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/inde=
x.rst
index cdb8b43ce7970a..ff2db9ab428d3c 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -20,3 +20,4 @@ KVM
    review-checklist
=20
    intel-tdx
+   tdx-tdp-mmu

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--Aew40JBmWCIbpsgg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY19NxwAKCRD2uYlJVVFO
o9qaAQCVOIc3CkEyOCXd9prfp+jxgWKmQqj/u5tVMqLG3nnYKQEA0yqxAC5RW3KQ
wh/SgCiIatrEzhbHk4ME/YxNwzFxIAc=
=Dg1Z
-----END PGP SIGNATURE-----

--Aew40JBmWCIbpsgg--
