Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2646D112E8B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 16:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfLDPeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 10:34:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53776 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728238AbfLDPeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 10:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575473689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohr+K9Wr9L1SwB4XbeQinW5OsnRUbekzuVwYWSF3DGY=;
        b=U8xbtYu4hl9nLHUcZWrbnMQWIbi12Rb2pfuB9OMDx//m1L6Urb8evIpi3rQbAZJrmu+QM7
        ttXCSFIv92Xw+ljs/mCp1pm7yRZG5usFnsLmoKP5n/MsMg6m/sJXEeV+JLC9bhBzf4LNfU
        jW2w1gE+pAxpHOZpkW8hNhFzII0Huw4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-89a8gExoPg-g5ckrsK2prQ-1; Wed, 04 Dec 2019 10:34:48 -0500
Received: by mail-wr1-f71.google.com with SMTP id u18so23192wrn.11
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 07:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ohr+K9Wr9L1SwB4XbeQinW5OsnRUbekzuVwYWSF3DGY=;
        b=iiRnIv3UG0Nrevvry94qlFH2k/Yw1vgVmVKgZVEDhdcLwpf20UJb3Zpp+QBB25c16o
         A11Fp7cXaIwyXTcOVuG+gXAii0E0yojkY9nNR8Hfxs96I7uH5bkqC/lxHtTplhi8R1/L
         F2XQUZ1+MyJ1clUDuFnFxD2qIy986qHNPOeTBVMixOj3zX7j41uCQo53kyjvfxwYTpGL
         QbGu6vNHQRhms5gS/IuIOi2gGqUsjevaozAe0A8t+pDUen2U8Oy31wGaWktd/9/AzsGU
         1PwjvL1K0RiHIraabDj5oXS0KLn6sKrpaRD+ek9LtcX4HfkOOTaRqlY9EwXcupx/eSFK
         973g==
X-Gm-Message-State: APjAAAVbTexqPgv2349qdwth7m0wmKmOrekMMT+GteALszBHlF+u3arz
        1Z+pZAxaiNtJLbTw+VmS0gNsEIEe0m8yUdmRDsNIPY8mHl8M4fDGpks0c6I3b0tDgevgUyCKhN4
        Ec2dMHycV8NAY
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr4615814wrv.144.1575473687068;
        Wed, 04 Dec 2019 07:34:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCwDAGc25fHrVIgk3hM96SB/lE+J0Sx+odhAXM45pVbtAz8iw4flzaRpnlM2iJmSz78wu3Ng==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr4615796wrv.144.1575473686830;
        Wed, 04 Dec 2019 07:34:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id c6sm6959402wmb.9.2019.12.04.07.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 07:34:46 -0800 (PST)
Subject: Re: [PATCH] target/i386: relax assert when old host kernels don't
 include msrs
To:     Catherine Ho <catherine.hecx@gmail.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
References: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
 <2ac1a83c-6958-1b49-295f-92149749fa7c@redhat.com>
 <CAEn6zmFex9WJ9jr5-0br7YzQZ=jA5bQn314OM+U=Q6ZGPiCRAg@mail.gmail.com>
 <714a0a86-4301-e756-654f-7765d4eb73db@redhat.com>
 <CAEn6zmHnTLZxa6Qv=8oDUPYpRD=rvGxJOLjd8Qb15k9-3U+CKw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
Date:   Wed, 4 Dec 2019 16:34:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAEn6zmHnTLZxa6Qv=8oDUPYpRD=rvGxJOLjd8Qb15k9-3U+CKw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 89a8gExoPg-g5ckrsK2prQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 16:07, Catherine Ho wrote:
>> Ok, so the problem is that some MSR didn't exist in that version.  Which
> I thought in my platform, the only MSR didn't exist is MSR_IA32_VMX_BASIC
> (0x480). If I remove this kvm_msr_entry_add(), everything is ok, the guest can
> be boot up successfully.
> 

MSR_IA32_VMX_BASIC was added in kvm-4.10.  Maybe the issue is the
_value_ that is being written to the VM is not valid?  Can you check
what's happening in vmx_restore_vmx_basic?

Paolo

