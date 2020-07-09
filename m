Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6618B21A716
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgGISbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:31:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgGISbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 14:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594319502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wPC1KCP3vcodNUQcDNiEe8+jRjBUgztwkFozwc2Ac0=;
        b=P8Oel7S/QIs0AChO7NoecynbFBgh+P2+O6b+QcLe70uHCsCDj61vV3UnZC95pIuWw2TTlg
        YDSKUv1Iq/o8gaxlEBBdbKv/9GjcIRLRPQngX+JISjXK2XOmpUOoV9mVpVVlsHMPfBViO3
        Uj2+zOi8TZs9tSjwKqB1l/FStH+SyOk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-DcBSsm5eMmKnPDb8FHQz3Q-1; Thu, 09 Jul 2020 14:31:40 -0400
X-MC-Unique: DcBSsm5eMmKnPDb8FHQz3Q-1
Received: by mail-wr1-f72.google.com with SMTP id y13so2717536wrp.13
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8wPC1KCP3vcodNUQcDNiEe8+jRjBUgztwkFozwc2Ac0=;
        b=iuoEhEL59oragowLQ2xeLO37bJ+7LprM2dnJEH0pL6VU9Z0TG3MLanaobAxR+0u6La
         jAzqrqYg0kVMwXU+h1cfE7I5yW5lby0ygWJ8GTEtOLuUH80HaqA4VU6B5UD0ljVECDKQ
         +PxKG7eQa3J0K4SGl29IQFpoXnyzVciM2nzK0hGUFbKwFWfGTBtrbzbGFRCZABlJHb4J
         SNddOTifhAJeam2LBdhv+7yMRSHYdJaBlAzmiD9W2CkXbdR7uJvyX4UfPNybgD6ndtBg
         ez7PzoSVuBgEMW/xjhpK4bPXAb9Fk0uC2L0d1wS6DIB4lZe9vtL3RMH1o6QQgdtiZI61
         C8Yw==
X-Gm-Message-State: AOAM531GxTZMu9xAEvi2DYCgnS7wr7MptcOzQvRJoG+uxQ9YEFA3wg02
        SgpJs7JWwX/qLjGW2RFjNKEReTG2tNdpg4Ku5Gj/2DJxefkPJ55k9yvVlH+TRVCJYVdAkKmHZ6B
        kY7RuJPevgI1g
X-Received: by 2002:a1c:c38a:: with SMTP id t132mr1255792wmf.1.1594319498977;
        Thu, 09 Jul 2020 11:31:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSZg+9erfbpQ5Y6fhf8LvyCyl8XNa8tXzSYFRcL2WsnIUymBe2DGqS43th0JRX+WyCxaixPw==
X-Received: by 2002:a1c:c38a:: with SMTP id t132mr1255780wmf.1.1594319498789;
        Thu, 09 Jul 2020 11:31:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id n16sm6537735wrq.39.2020.07.09.11.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 11:31:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: nSVM: vmentry ignores EFER.LMA and possibly
 RFLAGS.VM
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20200709095525.907771-1-pbonzini@redhat.com>
 <CALMp9eREY4e7kb22CxReNV83HwR7D_tBkn2i5LUbGLGe_yw5nQ@mail.gmail.com>
 <782fdf92-38f8-c081-9796-5344ab3050d5@redhat.com>
 <CALMp9eRSvdx+UHggLbvFPms3Li2KY-RjZhjGjcQ3=GbSB1YyyA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <717a1b5d-1bf3-5f72-147a-faccd4611b87@redhat.com>
Date:   Thu, 9 Jul 2020 20:31:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRSvdx+UHggLbvFPms3Li2KY-RjZhjGjcQ3=GbSB1YyyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 20:28, Jim Mattson wrote:
>> That said, the VMCB here is guest memory and it can change under our
>> feet between nested_vmcb_checks and nested_prepare_vmcb_save.  Copying
>> the whole save area is overkill, but we probably should copy at least
>> EFER/CR0/CR3/CR4 in a struct at the beginning of nested_svm_vmrun; this
>> way there'd be no TOC/TOU issues between nested_vmcb_checks and
>> nested_svm_vmrun.  This would also make it easier to reuse the checks in
>> svm_set_nested_state.  Maybe Maxim can look at it while I'm on vacation,
>> as he's eager to do more nSVM stuff. :D
>
> I fear that nested SVM is rife with TOCTTOU issues.

I am pretty sure about that, actually. :)

Another possibility to stomp them in a more efficient manner could be to
rely on the dirty flags, and use them to set up an in-memory copy of the
VMCB.

Paolo

