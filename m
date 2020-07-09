Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5328B21A72A
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgGISlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:41:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33438 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbgGISle (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 14:41:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594320093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yrog4kNVLv14gHPE6cxcCNEgoYv6zXzH5cGxxa/OAZY=;
        b=Wyrzt0tUqozVIa2CMVljA1Msv7L9e/lj2tkyY2gLNODZaIMr81Y282Nompv0G30TanhFls
        xKRsbRp6CY+4TaogyM9qmqSGCSHeGn3QXagIZnBY1+LDlHzxvEUWI0UYL9QB6q3MvdCNIa
        7Ou4p0+Yb+8nFZNAi9RNcfoUxMIHLIM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-KAUbcOKzNieVPOpUU9V7cA-1; Thu, 09 Jul 2020 14:41:31 -0400
X-MC-Unique: KAUbcOKzNieVPOpUU9V7cA-1
Received: by mail-wr1-f70.google.com with SMTP id 89so2739185wrr.15
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yrog4kNVLv14gHPE6cxcCNEgoYv6zXzH5cGxxa/OAZY=;
        b=R0oYLdGpH/bUNTu/UTy4Rce1hYgOrDcXN5T7kwUvZD74ANcMRpnVfnBAzKImKlw6SQ
         d20sTLrQmrMXVB4pJmtWPBacPIyNL6j4lsA4Y2fkqK4OIIjiUj3nojb4OYghx/fYIRnt
         4jV5qaZOkZ+z5K8OrI34znU4U3wpHuPd/GM6a6GIceORzWrnt87+K+iXwmR5W+aoDQD3
         4ZnOv/+OD62HwzqcHlfHH0kPiJMWFynsQ1AVMn96+AUjekVO+rp/2QJL6JI+0/7Nm4Nf
         Mz0++AfmFyul53lDJY3gXK6jMCVaRvMgB+p+rShQqEQqzPR4f/ZsiJMlCftrWqdI/eQx
         qFQQ==
X-Gm-Message-State: AOAM533T1jjNH51BOA4xeN9FEqH0oXeK93ZBRYKT4sI4uyZQlHmvGXfo
        d0emUuW0eVt0nAj20RThD+YzK1U2gujjnvvCPGIbOpRredLCNv7c6V4NdZAYLW3O3q4OpM7y1CD
        7ClfSKVm5w6uA
X-Received: by 2002:a5d:68c7:: with SMTP id p7mr68029851wrw.16.1594320090376;
        Thu, 09 Jul 2020 11:41:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5YRD9Q0mxA3lflFoAyXPxrfqh8BMKXlV8oRf/72ycXWIrO5lzKOihwddGLNRG15BuHyZlcg==
X-Received: by 2002:a5d:68c7:: with SMTP id p7mr68029833wrw.16.1594320090103;
        Thu, 09 Jul 2020 11:41:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j15sm6523281wrx.69.2020.07.09.11.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 11:41:29 -0700 (PDT)
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
 <717a1b5d-1bf3-5f72-147a-faccd4611b87@redhat.com>
 <CALMp9eThSjLY92-WURobbJBHRKLxGuYPLBWMnq+=FxxYHquTiw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a341f7ca-4739-db84-74e0-27859bba9eeb@redhat.com>
Date:   Thu, 9 Jul 2020 20:41:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eThSjLY92-WURobbJBHRKLxGuYPLBWMnq+=FxxYHquTiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 20:40, Jim Mattson wrote:
> On Thu, Jul 9, 2020 at 11:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 09/07/20 20:28, Jim Mattson wrote:
>>>> That said, the VMCB here is guest memory and it can change under our
>>>> feet between nested_vmcb_checks and nested_prepare_vmcb_save.  Copying
>>>> the whole save area is overkill, but we probably should copy at least
>>>> EFER/CR0/CR3/CR4 in a struct at the beginning of nested_svm_vmrun; this
>>>> way there'd be no TOC/TOU issues between nested_vmcb_checks and
>>>> nested_svm_vmrun.  This would also make it easier to reuse the checks in
>>>> svm_set_nested_state.  Maybe Maxim can look at it while I'm on vacation,
>>>> as he's eager to do more nSVM stuff. :D
>>>
>>> I fear that nested SVM is rife with TOCTTOU issues.
>>
>> I am pretty sure about that, actually. :)
>>
>> Another possibility to stomp them in a more efficient manner could be to
>> rely on the dirty flags, and use them to set up an in-memory copy of the
>> VMCB.
> 
> That sounds like a great idea! Is Maxim going to look into that?
> 

Now he is!

Paolo

