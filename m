Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300CE177BBA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgCCQSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:18:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34834 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730229AbgCCQSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583252292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ux1LbKEH1m8oXcQEuc/U7Ti4AulME3jbfobJPAiWr6U=;
        b=Nbu2AaDLW1bbAk/SUyzTcpyfRzUgmnogY0ndlL0DopJonAnTWRcTnIwp4zyjJtUGKLYaBx
        brcrLR9TW+raziIAy2l1K0noYhf0Rv6h2d06SRl8r7WrUfd6mj6EtyN+oJ3nEcjEZw7mp+
        /6GoHZGPDv+nRgurw8Rq3+c52+qtVCo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-wb-kGGUeNPujKSIsFXNwpw-1; Tue, 03 Mar 2020 11:18:10 -0500
X-MC-Unique: wb-kGGUeNPujKSIsFXNwpw-1
Received: by mail-wm1-f69.google.com with SMTP id p4so1102161wmp.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ux1LbKEH1m8oXcQEuc/U7Ti4AulME3jbfobJPAiWr6U=;
        b=UXxdIuTvr26QfTSQMZZT13GlklQefOObXt44Wa3IwJPVdyL7d0veCb2i1qg4NPrDEq
         bliTd5xRw1Mn6ZJeVFl2T21G4VmauYsOr1b2J4uY3VWoBzwnpLBk7gkO77J1jS43Z5Pz
         XyK0hVdXHdXzdEOzBbfhKUG4t2B6BGDnOHwHuZDMt5ZAKjbMp0EW51ExBqSaUlh29Yh7
         BoOfVqiSYkagvN2HlH5/sNr6v16BUR0zqBw8eszYFECrXyG5YVdJMvW52T7mo29tpI6l
         RhW2FT6lMoYENN16ReUXdyhJX9HhYfn5nFuB/0NiCyzyJ3j/l9V7MvIW53oJeg0wh6cA
         KwNw==
X-Gm-Message-State: ANhLgQ1C5IEKMKRNdtC9B4RgxndS8wful6zFm6RYYE/aLCellMq1QKAo
        p542+E0vUeW0stJWOj2ksHu4uT8wIIaDCESKhD/nGtWbah0asKzuHBkYHyqbRL6wIDv+cwVOytA
        dCuV8X92zxDo6
X-Received: by 2002:adf:f491:: with SMTP id l17mr6715442wro.149.1583252289252;
        Tue, 03 Mar 2020 08:18:09 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtwoSxwVgqZLc0Y9OACaZM95EIDRl4nCEMRKLI2B2zsM4WldStnyj0BJz2YJF13qOqzBE61vQ==
X-Received: by 2002:adf:f491:: with SMTP id l17mr6715424wro.149.1583252289089;
        Tue, 03 Mar 2020 08:18:09 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 16sm4551998wmi.0.2020.03.03.08.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:18:08 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/13] KVM: x86: Dynamically allocate per-vCPU emulation context
In-Reply-To: <20200303145746.GA1439@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-9-sean.j.christopherson@intel.com> <87wo89i7e3.fsf@vitty.brq.redhat.com> <83bd7c0c-ac3c-8ab5-091f-598324156d27@redhat.com> <20200303145746.GA1439@linux.intel.com>
Date:   Tue, 03 Mar 2020 17:18:07 +0100
Message-ID: <8736apfm4g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Mar 03, 2020 at 11:26:21AM +0100, Paolo Bonzini wrote:
>> On 26/02/20 18:29, Vitaly Kuznetsov wrote:
>> >>  struct x86_emulate_ctxt {
>> >> +	void *vcpu;
>> > Why 'void *'? I changed this to 'struct kvm_vcpu *' and it seems to
>> > compile just fine...
>> > 
>> 
>> I guess because it's really just an opaque pointer; using void* ensures
>> that the emulator doesn't break the emulator ops abstraction.
>
> Ya, it prevents the emulator from directly deferencing the vcpu.
>

Makes sense, a comment like /* Should never be dereferenced by the
emulater */ would've helped)

-- 
Vitaly

