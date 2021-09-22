Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D2F414D74
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 17:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhIVPyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhIVPyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 11:54:15 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7EC061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 08:52:45 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u18so3193588pgf.0
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 08:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Qoxd4fL0Eld7fb+Hk+Vjj7yaw+v+nFRAtpg8iAdaBaE=;
        b=kNmGYzws0owsOXlLO9/3wRNXi/TTeIeLm1842DEE9RfWra6CYNFK7xDB2APkm7Yg3N
         8wWnlUhPsTuKb+Rlh8z/Wa3AannY5UVRDV/sw7YucAOAFhAVufS2sLE9HeUh4wfuHZGb
         7X3yLKQtF9GHJ8Fgb1g7LusNPr2NAyIyvUE5b9ZYR/LrTtttb60edvROuZtlxPeyTJPE
         Ehz6F62ILhZK+TMELfKjotnDvkmONNPgM56xegGcKlmMFvbQo/hxrb+VUlWsy1Z/iXU6
         SAqinHzAlucaD0FOkB7+KpY8nX53XHL64tXf2ZXDDBhH+5ZsWZ0xaqUsWGTQjaXTEKHU
         qjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Qoxd4fL0Eld7fb+Hk+Vjj7yaw+v+nFRAtpg8iAdaBaE=;
        b=KgT1cOw8vfW4rUOALkZPekLts9xc/9TamsC5amoYYW5MDzZ0GLOmtDsRIH0lkRsDGu
         Z5yttE07kGcZSclBeZtmLqYquzYCMU/tPU27e9dhcUZFLkVyrwTyCtSfJrH2qN1OUmod
         M532aJARE1hDri5lKZRlLN1YQzydu21nqxYmQ5VEMyEP2IzeDB85gjM9WmvVZ7Jump+q
         AA4HKMSJhAp/4I6iWHdAfdItvUMtOJfkcx5orwSy4ZFoALWfEsyeqweIdN7Gf1VQjZBy
         ZLZejMsf+Di+PFxr73KGAyObJp0O5HqCp01ChOANK0VV+QLeDLkYPapBhoGCt7s96DNO
         6yAg==
X-Gm-Message-State: AOAM5323xhgZZPINiKPgcnZVzsWIgKNlB5hjhFZeSiL0Sca9gfK0hAQX
        O/sOLAaH94xbqegp9d4R583UzQ==
X-Google-Smtp-Source: ABdhPJyp4a0+4xkizT2QHY/shekgX2RvMyXGh1bTuBeXvT6HfR6fqpzNgsYUFK3EWtLqd+6oyxUo8g==
X-Received: by 2002:a62:1e43:0:b0:447:cb0b:4c6e with SMTP id e64-20020a621e43000000b00447cb0b4c6emr80119pfe.1.1632325964496;
        Wed, 22 Sep 2021 08:52:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm2852801pfn.107.2021.09.22.08.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:52:43 -0700 (PDT)
Date:   Wed, 22 Sep 2021 15:52:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 0/7] KVM: few more SMM fixes
Message-ID: <YUtRSK8SwMfEZ2ca@google.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
 <22916f0c-2e3a-1fd6-905e-5d647c15c45b@redhat.com>
 <YUtBqsiur6uFWh3o@google.com>
 <427038b4-a856-826c-e9f4-01678d33ab83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <427038b4-a856-826c-e9f4-01678d33ab83@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> On 22/09/21 16:46, Sean Christopherson wrote:
> > On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> > > On 13/09/21 16:09, Maxim Levitsky wrote:
> > > >     KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
> > 
> > ...
> > > Queued, thanks.  However, I'm keeping patch 1 for 5.16 only.
> > 
> > I'm pretty sure the above patch is wrong, emulation_required can simply be
> > cleared on emulated VM-Exit.
> 
> Are you sure?

Pretty sure, but not 100% sure :-)

> I think you can at least set the host segment fields to a data segment that
> requires emulation.  For example the DPL of the host DS is hardcoded to zero,
> but the RPL comes from the selector field and the DS selector is not
> validated.

HOST_DS_SEL is validated:

  In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the RPL
  (bits 1:0) and the TI flag (bit 2) must be 0.

> Therefore a subsequent vmentry could fail the access rights tests of 26.3.1.2
> Checks on Guest Segment Registers:

Yes, but this path is loading host state on VM-Exit.

> DS, ES, FS, GS. The DPL cannot be less than the RPL in the selector field if
> (1) the “unrestricted guest” VM-execution control is 0; (2) the register is
> usable; and (3) the Type in the access-rights field is in the range 0 – 11
> (data segment or non-conforming code segment).
> 
> Paolo
> 
