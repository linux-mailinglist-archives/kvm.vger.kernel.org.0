Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019B371878
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhECPxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:53:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhECPxF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620057131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgYx5TvUhkEhNhkber8yC1nc2KvBXPUk7IuRSfPajIg=;
        b=BmZuVSF+k7bnpNwwIsbm5KRVqsqogsvTsvZj9gNB5kI5kDDBTcZfaKYvfYlmrudgxzyNPg
        9NSN6tzf8zscTwZ36r0nzy+CBrWTaKwmn54YuEuhLtNGuNYRKOIU29Q0oQ7Wm4wot4EBdo
        cgGpRPxBjKZcceYNPIe3D9lAmV7XbUg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-WUA2DQXiN9eiavtMYsDoKw-1; Mon, 03 May 2021 11:52:07 -0400
X-MC-Unique: WUA2DQXiN9eiavtMYsDoKw-1
Received: by mail-ej1-f72.google.com with SMTP id qk30-20020a170906d9deb02903916754e1b6so2235492ejb.2
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 08:52:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AgYx5TvUhkEhNhkber8yC1nc2KvBXPUk7IuRSfPajIg=;
        b=pWGc8ocmcCN2+JrYY+3Myx+YFWD4+kDxDfHi3qRGBQYDRJ1yT0mYcuNZtUZt/TcgjR
         bCMDwX+ZLm+g0L62OzBkV3+kJfH3K0wn4qwkzc7RFiIF0fITahDaRc4nAs2vXsUF6hq9
         9Idi7cWdLqPFR8/SCHGVLYfpQbQofxdY6dUBs1KB9FB+/scmabdz/jHBt3BHsv66tO0j
         lhdxlDV/N+UDTACavV20o7q6YNJkuA9txAXU8ZSMw+KonjVup67wAUtwSAXDeQjgJFwm
         +YITaIZl2oPTbEwpJ2EtYhbU9r2NdZk6EwPHsLC+STH07b2sv6NTIsRIa6SigjiXx2YE
         etHg==
X-Gm-Message-State: AOAM530yJcdw9SWBl4xEtB5kuMAOi6yv77fMArKZBriaPz2RUKS3mXYL
        UyI9nJsMEu8nTA5z2MN+6EmMPjqaX+zVt5VG/DEyDnpZa0Au9KsQyY/2VWdJohxhUiHHu+lR5Yx
        zEikE1rZxu1nt
X-Received: by 2002:a17:906:6b96:: with SMTP id l22mr17170286ejr.364.1620057126225;
        Mon, 03 May 2021 08:52:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCUo5Gkq+n05BuEimfpfMnbNcyojuAtgJrwufNe0jzK2qdxJaPLeyw1nkoONnfSe84qDPC4A==
X-Received: by 2002:a17:906:6b96:: with SMTP id l22mr17170271ejr.364.1620057126046;
        Mon, 03 May 2021 08:52:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hp29sm45178ejc.47.2021.05.03.08.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 08:52:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: nVMX: Fix migration of nested guests when
 eVMCS is in use
In-Reply-To: <f2f7020d-9293-d9bb-093f-b9c857a962d8@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <f2f7020d-9293-d9bb-093f-b9c857a962d8@redhat.com>
Date:   Mon, 03 May 2021 17:52:05 +0200
Message-ID: <87pmy7yfve.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 03/05/21 17:08, Vitaly Kuznetsov wrote:
>> Win10 guests with WSL2 enabled sometimes crash on migration when
>> enlightened VMCS was used. The condition seems to be induced by the
>> situation when L2->L1 exit is caused immediately after migration and
>> before L2 gets a chance to run (e.g. when there's an interrupt pending).
>
> Interesting, I think it gets to nested_vmx_vmexit before
>
>                  if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
>                          if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
>                                  r = 0;
>                                  goto out;
>                          }
>                  }
>
> due to the infamous calls to check_nested_events that are scattered
> through KVM?

Yea,

vcpu_run() -> kvm_vcpu_running() -> vmx_check_nested_events() if I
remember it correctly.

-- 
Vitaly

