Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC861DC901
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgEUIri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 04:47:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728389AbgEUIri (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 May 2020 04:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590050856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3jX6C31rXzqpDtPFoCEw/wmbOx4jCKhOeiRK6RvOv+Q=;
        b=UpyEqpPrthIUyeOlrtMKwIqsARElWDXPFu29nqgvwrb1HvOnOTGJajzUwTgUwGFA0UVZVt
        G71QaagdNJrw8QchqKjL/bt8U97WbI3beLEVLBJjLRcWDs1h+me34Y9jWZ5pPBsAybuY2j
        1sAWfmaXmSLiNvoLhu4fg1KVpPJCSCQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-Bi78FWqKPgWTFBrU5F_YBg-1; Thu, 21 May 2020 04:47:34 -0400
X-MC-Unique: Bi78FWqKPgWTFBrU5F_YBg-1
Received: by mail-ej1-f72.google.com with SMTP id ci7so374547ejb.2
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 01:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3jX6C31rXzqpDtPFoCEw/wmbOx4jCKhOeiRK6RvOv+Q=;
        b=QeJRadBdbShu+bKQ1xcZ/wqGvfYnhPX/O5+1MKSHh+xf+1Y70uAPkkeL0bBHHV78zp
         eMRWRJAemeshwMylAj+/GC3yCMo58CY1YknovhLEUPzd7+CWSATfttoN+saCzc8ky/Cl
         +UngPRqSF81Nks+Bag2Zv2yyulVDNDseQb0/7iSyJaSN2ytQLSo/4FBLxPgv4QvVY/UB
         xlcch8CC4jZiYS8EVTZ98cduT7ZSD14UA6giCWnOPkPagrXU0YuYLIAGP+7c2n91PlTT
         8E1NtG3EXO+rOJtd1Ip9xysb+hM4Z2A3J+1C+oWUMgtDGQbb+fN2vD94NOkJBncaYf4+
         7JRQ==
X-Gm-Message-State: AOAM532ArnI1NXEMrvOpyhpVuqz7BZqoITTHm6yehbq+40XGjQHkvk+R
        M3DmMQuAGknuSXrda+t0ikPDX7fUaIT8Fk5XEgkEJdordX1qX2MDKOO1iIJiDFRIccFejodxUxz
        A/wdXMJf72i8i
X-Received: by 2002:a50:fd97:: with SMTP id o23mr6967873edt.363.1590050853616;
        Thu, 21 May 2020 01:47:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybq7ACl+Alt35riX7FeuHUVe6oJNYaIk5RXqhue1DgafeG4Rbj6gbCi+XZ7hqQUm1XNYqgqA==
X-Received: by 2002:a50:fd97:: with SMTP id o23mr6967863edt.363.1590050853409;
        Thu, 21 May 2020 01:47:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id mb1sm4358079ejb.109.2020.05.21.01.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 01:47:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Fix VMX preemption timer migration
In-Reply-To: <d21f47c0-dd48-53f8-ffbb-8d6f8637b50b@redhat.com>
References: <20200519222238.213574-1-makarandsonare@google.com> <20200519222238.213574-2-makarandsonare@google.com> <87v9kqsfdh.fsf@vitty.brq.redhat.com> <CA+qz5sppOJe5meVqdgW-H=_2ptmmP+s3H9iVicA0SRBpy4g5tQ@mail.gmail.com> <d21f47c0-dd48-53f8-ffbb-8d6f8637b50b@redhat.com>
Date:   Thu, 21 May 2020 10:47:31 +0200
Message-ID: <87mu61smho.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 20/05/20 20:53, Makarand Sonare wrote:
>>>
>>>> +
>>>> +		if (get_user(vmx->nested.preemption_timer_deadline,
>>>> +			     &user_vmx_nested_state->preemption_timer_deadline)) {
>>> ... tt also seems that we expect user_vmx_nested_state to always have
>>> all fields, e.g. here the offset of 'preemption_timer_deadline' is
>>> static, we always expect it to be after shadow vmcs. I think we need a
>>> way to calculate the offset dynamically and not require everything to be
>>> present.
>>>
>> Would it suffice if I move preemption_timer_deadline field to
>> kvm_vmx_nested_state_hdr?
>> 
>
> Yes, please do so.  The header is exactly for cases like this where we
> have small fields that hold non-architectural pieces of state.
>

This can definitely work here (and I'm not at all against this solution)
but going forward it seems we'll inevitably need a convenient way to
handle sparse/extensible 'data'. Also, the header is 128 bytes only.

I'd suggest we add an u32/u64 bit set to the header (which will be separate
for vmx/svm structures) describing what is and what's not in vmx/svm
specific 'data', this way we can easily validate the size and get the
right offsets. Also, we'll start saving bits in arch neutral 'flags' as
we don't have that many :-)

-- 
Vitaly

