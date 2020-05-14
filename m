Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB731D407A
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 00:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgENWF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 18:05:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45530 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbgENWF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 18:05:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589493926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WbD5g5bGH+nPMmGQ14q3KYBCwhmBSOIy/E7pqLF8qco=;
        b=HgmWWKpP7fjRMrxT2DGzUivS9oD8pwkg5U4SezAOD9nbWE06CIFBuxs4WxLvhsueKkSAy/
        dbxI84PLlLlho7UmJPXPASonF8xC88GeZZsfOpUg3vrhH60fiCLD+B491h6r+37SNu9XWw
        rvCpliYZ8Duciu3lTimvQ/vJzO3vTIc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-02n3hhRjO--NfV9S_8EtcQ-1; Thu, 14 May 2020 18:05:24 -0400
X-MC-Unique: 02n3hhRjO--NfV9S_8EtcQ-1
Received: by mail-qv1-f72.google.com with SMTP id o11so467672qve.21
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 15:05:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WbD5g5bGH+nPMmGQ14q3KYBCwhmBSOIy/E7pqLF8qco=;
        b=KDwh9N4LJtoZri2qg63UaUPdxLh4/oZVBZtD7I5chzcgPdMWSG5tlMA0QF7UJB2vNZ
         MFddFd+c0p+35OEJ5zpyYWqERFymBEgma4juArGCHpDqU5j3vuVrPae27nFlZLgI0Mo7
         oUxWDHFnBOtgf645WTJJfroGXxMDO9yY/WVYm0803YTpj7a69uCxi4L4yxa7fIegwyFV
         q6rUcR3YEzZSSa814UAfWr8NnYR4w6vjG0kdbleY9ilnsL25Z4+MS6aMXfkSebhb6AVm
         AznhwXqr6Ze+DdM4+04VBsFrEwFn1YUlyLJ4dQ7AzJdrG9ZiAeebZTqfSK6smdPjnf9I
         Zv9g==
X-Gm-Message-State: AOAM531sVgJOSh5LREkMx//dBu2yNA92bskpaubLgYZZwxi0aRwnn5sW
        wFR8LtqPhUWZ5I8ccUN65nAUhuUfoAyIjWDEVASPmwNmALp+rsGaY2Pq+I8moP73NpsN2gV86TG
        h/1fG93h2xTKZ
X-Received: by 2002:a37:a687:: with SMTP id p129mr551126qke.45.1589493924463;
        Thu, 14 May 2020 15:05:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh13mhxrDmHNJ8hptY5k7/JfPCSEmEv15VKAaaUnkUI+iGTOJzFoJ4FomI5IJPGc2XiaiEog==
X-Received: by 2002:a37:a687:: with SMTP id p129mr551104qke.45.1589493924227;
        Thu, 14 May 2020 15:05:24 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y28sm373922qtc.62.2020.05.14.15.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 15:05:23 -0700 (PDT)
Date:   Thu, 14 May 2020 18:05:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
Message-ID: <20200514220516.GC449815@xz-x1>
References: <20200514180540.52407-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200514180540.52407-1-vkuznets@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 08:05:35PM +0200, Vitaly Kuznetsov wrote:
> The idea of the patchset was suggested by Michael S. Tsirkin.
> 
> PCIe config space can (depending on the configuration) be quite big but
> usually is sparsely populated. Guest may scan it by accessing individual
> device's page which, when device is missing, is supposed to have 'pci
> holes' semantics: reads return '0xff' and writes get discarded. Currently,
> userspace has to allocate real memory for these holes and fill them with
> '0xff'. Moreover, different VMs usually require different memory.
> 
> The idea behind the feature introduced by this patch is: let's have a
> single read-only page filled with '0xff' in KVM and map it to all such
> PCI holes in all VMs. This will free userspace of obligation to allocate
> real memory and also allow us to speed up access to these holes as we
> can aggressively map the whole slot upon first fault.
> 
> RFC. I've only tested the feature with the selftest (PATCH5) on Intel/AMD
> with and wiuthout EPT/NPT. I haven't tested memslot modifications yet.
> 
> Patches are against kvm/next.

Hi, Vitaly,

Could this be done in userspace with existing techniques?

E.g., shm_open() with a handle and fill one 0xff page, then remap it to
anywhere needed in QEMU?

Thanks,

-- 
Peter Xu

