Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6B2F3DD0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbhALVqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbhALVqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:46:12 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF25BC061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:45:32 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c12so2203798pfo.10
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vFJ/rFa4+Sg1hSl8x3O3B/ZIA0gEVYoqC8NmFooiOm0=;
        b=wCA645tOz/mMX8wP55qrAguMJS197Qs3wIkh0y4st7n/0CHiK/UwPZwyCO+n4vY8s5
         ZrTjQw4LZbhAN6v5s9I8MGW4bdXeceGByJNmlzbYr8pIV0DzKGAidchlmrg3hP/AvTj2
         WcUcvrxiLt0C32T/oG2C7RGVw9VMEP7/agFvlioqjyNWZc6SXScABdHRvib1HrZhZbwq
         apHaqKGIkz+N9oD1C7pwvss4yzcpQikEEfTSxKeqz7sbw3OSm85JN4yfBi18BPuHiuI5
         ygMJg5XjcGYUSYg1Vwn5nuVxOsp8AF1WiEQtloclykGZrQDt7ryFwfP81LzyZaKl3VrE
         Mldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vFJ/rFa4+Sg1hSl8x3O3B/ZIA0gEVYoqC8NmFooiOm0=;
        b=OLoJWVH4M0RDbtC+z1DJv6vhU1DfUj/C5t4YFyMK2bMfDtRiZ9tTHkA77Hvcy7YvLi
         OCP4Ysq8diG+ahx0Fdg/ieScT/SD0py6ccC1KQMnSS5gWPDMEbaSVX2g3j0ZX8F+4E+d
         2h71C+jBxAxC2VbfGwImlTUu6psRhh5gQBUe0PWlmfnfEZ4Nn8HB8Ru4aRWsCixmKat4
         SklSTTmdVXjol70DBUX2Mo4ONvzuXmdxkwpLJpZExZA8iONlQH1dbFJXYKnqFGaffm+E
         heBXG/J1OBljinZCPcyhPZ6q3z/a4UUwdtVe+JDInf+NJZ0RNgZbJVWjbVxp717+qqtg
         fMBQ==
X-Gm-Message-State: AOAM530HKorbpx85zCoa/JWUBgvP1mj7c7UjDQazlZKlpOFkq1D7iHWl
        CRlq/qR6NPcKPtP9WnVvccwIbQ==
X-Google-Smtp-Source: ABdhPJzUiHLIf6SN0zRWzersJQF2wrvUwAL6nSwXwPhNQPaix2oiqFI7jyJ+ueOK+QoT0VqFHLQ3Qw==
X-Received: by 2002:a63:cf06:: with SMTP id j6mr1049819pgg.195.1610487931868;
        Tue, 12 Jan 2021 13:45:31 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id k3sm4272752pgm.94.2021.01.12.13.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:45:31 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:45:24 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free
 list to separate helper
Message-ID: <X/4YdCN9LwZGompH@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
 <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
 <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Kai Huang wrote:
> On Tue, 12 Jan 2021 00:38:40 +0200 Jarkko Sakkinen wrote:
> > On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > SGX virtualization requires to allocate "raw" EPC and use it as virtual
> > > EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > > knowledge of which pages are SECS with non-zero child counts.
> > > 
> > > Split sgx_free_page() into two parts so that the "add to free list"
> > > part can be used by virtual EPC without having to modify the EREMOVE
> > > logic in sgx_free_page().
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > 
> > I have a better idea with the same outcome for KVM.
> > 
> > https://lore.kernel.org/linux-sgx/20210111223610.62261-1-jarkko@kernel.org/T/#t
> 
> I agree with your patch this one can be replaced. I'll include your patch in
> next version, and once it is upstreamed, it can be removed in my series.
> 
> Sean, please let me know if you have objection.

6 of one, half dozen of the other.  I liked not having to modify the existing
call sites, but it's your code.

Though on that topic, this snippet is wrong:

@@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
+		sgx_reset_epc_page(entry->epc_page);
+		sgx_free_epc_page(entry->epc_page);

s/entry/va_page in the new code.

P.S. I apparently hadn't been subscribed linux-sgx and so didn't see those
     patches.  I'm now subscribed and can chime-in as needed.
