Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225F0475653
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhLOK1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbhLOK1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 05:27:52 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CEBC061574;
        Wed, 15 Dec 2021 02:27:51 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a18so37322702wrn.6;
        Wed, 15 Dec 2021 02:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P0MRx/RGW4ziN8S9wCPS713ruRBCA/Uwb0Xtcax2re0=;
        b=cB1BkPp/KU5opERA59Pymdqn+XTfwiee7WOcf5OJBWK6K42TUiRUafUVtUo3HW+ywB
         zXzdAHnGJUuhQMZt64kZvbeVxbjasFIx2IQ5d0yuEHQK+mAe4x16UvjWh50ekSAXQjkO
         QGO07zYHVd0YBc2uWgpje+bbFKu9bM3Ivo/CvAoatP968zQmEL2/I2DMpUnuAJWWwuDj
         gVSHuV6GWmLuJo4W8Vz8XWWNOnNwvGvoogMa6Cw/9vPeU6LYm40tUvBSZXxxMkxSskvv
         YWX0EMHgtWONSVPE6I8fQ3u6G5/HA4Z3pO+LDAX1d+CbxObX+vyFzwSoHuAUobz5nsnw
         35VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P0MRx/RGW4ziN8S9wCPS713ruRBCA/Uwb0Xtcax2re0=;
        b=GHU5JGAA1ugEusUZ9A/bJUcNyIZ2UoJqgFFVNh5H9QKaNz+QtEkRs8Wuhqsyw/wBLB
         AVCu7EsmtfinnOwO3Xt0swhe0sL/aSb4vW/99/dJJfb6ElbDLzeDXNLOxcYvPVHDaNOq
         n/QuBSWTRJgVOM//5wxTDBXnPXkB7nQiszoFdSy6uuzk6e9EgDMCG45Cwy3POy3CkoN1
         nkaYtL0Jv1hG0aWFGr9zBtVx401e01Fp+qfUax7uRoGT5h8Tpe0TkFmRqnm3vnr1bhnb
         iUgkNwHwxuxejjZ6L667TGsXrmdiNtCGo/y7zHVci/k3wHj2HMxrLOjXAyCwM5nx+Xo2
         SRgw==
X-Gm-Message-State: AOAM530kgduuHaBvaTf5Apndnf9K7vGmp0jdogL9Mx3zNFW/4YHmAxtm
        ynjvTT9a+LTynvmwMD2GjU8=
X-Google-Smtp-Source: ABdhPJwHCN8T0doYu3a8IuehnhXg97GmtDWwj2/LtyTOLHVxXdJS9PowhVdFM1rwt5vrIogSO1a0Iw==
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr3815067wry.303.1639564070519;
        Wed, 15 Dec 2021 02:27:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c12sm1817241wrr.108.2021.12.15.02.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:27:50 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
Date:   Wed, 15 Dec 2021 11:27:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <878rwmrxgb.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 11:09, Thomas Gleixner wrote:
> Lets assume the restore order is XSTATE, XCR0, XFD:
> 
>       XSTATE has everything in init state, which means the default
>       buffer is good enough
> 
>       XCR0 has everything enabled including AMX, so the buffer is
>       expanded
> 
>       XFD has AMX disable set, which means the buffer expansion was
>       pointless
> 
> If we go there, then we can just use a full expanded buffer for KVM
> unconditionally and be done with it. That spares a lot of code.

If we decide to use a full expanded buffer as soon as KVM_SET_CPUID2 is 
done, that would work for me.  Basically KVM_SET_CPUID2 would:

- check bits from CPUID[0xD] against the prctl requested with GUEST_PERM

- return with -ENXIO or whatever if any dynamic bits were not requested

- otherwise call fpstate_realloc if there are any dynamic bits requested

Considering that in practice all Linux guests with AMX would have XFD 
passthrough (because if there's no prctl, Linux keeps AMX disabled in 
XFD), this removes the need to do all the #NM handling too.  Just make 
XFD passthrough if it can ever be set to a nonzero value.  This costs an 
RDMSR per vmexit even if neither the host nor the guest ever use AMX.

That said, if we don't want to use a full expanded buffer, I don't 
expect any issue with requiring XFD first then XCR0 then XSAVE.  As Juan 
said, QEMU first gets everything from the migration stream and then 
restores it.  So yes, the QEMU code is complicated and messy but we can 
change the order without breaking migration from old to new QEMU.  QEMU 
also forbids migration if there's any CPUID feature that it does not 
understand, so the old versions that don't understand QEMU won't migrate 
AMX (with no possibility to override).

Paolo
