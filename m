Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2CC4B0F01
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 14:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbiBJNoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 08:44:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbiBJNoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 08:44:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A90CAC59
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 05:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644500646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HukbEX1iLYdDJ31wYXwYp+eLvMjQ3m0iy3Hcm3qunp0=;
        b=hApsUZO972oQt8XDfm0xnjnTmnBywvzB9wbFVZ/9CIivlgIrJ7vs3qlO9uHrq2hSIQUm0N
        0CRNNZDy46k/yLQw7CL04ezPNsiSaAADJlJIs8629+3O9eX3FV4LkhkAcr0xdsq02oOoQR
        w9U+uo/26XFMnt4rO6OFe4Drr/lvJvw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-lNJXc6OGP4S4AIB70CVCkQ-1; Thu, 10 Feb 2022 08:44:05 -0500
X-MC-Unique: lNJXc6OGP4S4AIB70CVCkQ-1
Received: by mail-ej1-f72.google.com with SMTP id hr36-20020a1709073fa400b006cd2c703959so2733684ejc.14
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 05:44:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HukbEX1iLYdDJ31wYXwYp+eLvMjQ3m0iy3Hcm3qunp0=;
        b=O6324ZS9EfshZlcV0dNLTwVxqOwH3vSqNW9/mcgUKgutuuhHEAqpdAZYZU46qJevYT
         1OzxUBWYOS5OoziQmjLn/EPU9NHhzVqX/v7Ium7evncjDNsLgPwBLAaiaF9yXBlDlh6B
         VNWL91WXlAuQeju29d6PfVm9hTwNw7hc1+Ty0kt6x0W4pZz7++ftVhjo1tAPLYoqhgYh
         A9BqK7IPueoteGt3uPW5rEsvdHRqKzBGei4VNJ2wsbs8fnNHfYUmtRC5d3euW8Ln6G2D
         /TgLEy7ZImk+l94axaKjS9tPTf0oPFsEAnQ/cjkEW9wTbEuTJ9iErK8iym9c26F3EtAV
         oyZg==
X-Gm-Message-State: AOAM531Zimdh5t6Ktw+BvouEr9CgDne5wag+ebuNYX39/3W07iuw13SR
        7qU5374u9ZpHzT6+MvuoxvEyMdr5Bvsga05zKowbEd3NxWZAJ6XXiI7IlhXsJYmIjDdefdeZzyn
        jllae3m2j9lrkSDNyABzF+P4fYP8nA5coDeral54yuaUON9ikMtBUW6hpulQxXSPp
X-Received: by 2002:a17:907:6eac:: with SMTP id sh44mr6541911ejc.473.1644500644067;
        Thu, 10 Feb 2022 05:44:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsG5F95b3qoXWmkcozPYH9cLsI1PgOknid3fLwBvijBOTGZzV34fwk4HK8AYgRtyjioqVrOA==
X-Received: by 2002:a17:907:6eac:: with SMTP id sh44mr6541885ejc.473.1644500643710;
        Thu, 10 Feb 2022 05:44:03 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n24sm4005377ejb.23.2022.02.10.05.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 05:44:02 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
In-Reply-To: <87tud87xnr.fsf@redhat.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
 <87bkzh9wkd.fsf@redhat.com> <YgKjDm5OdSOKIdAo@google.com>
 <87wni48b11.fsf@redhat.com> <YgPqV8EZFnENj41D@google.com>
 <87tud87xnr.fsf@redhat.com>
Date:   Thu, 10 Feb 2022 14:44:02 +0100
Message-ID: <87iltm96ql.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> On Wed, Feb 09, 2022, Vitaly Kuznetsov wrote:
>>> Sean Christopherson <seanjc@google.com> writes:
>>> 
>>> > On Tue, Feb 08, 2022, Vitaly Kuznetsov wrote:
>>> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
>>> >> > and hv-avic only mentions AutoEOI feature.
>>> >> 
>>> >> True, this is hidden in "The enlightenment allows to use Hyper-V SynIC
>>> >> with hardware APICv/AVIC enabled". Any suggestions on how to improve
>>> >> this are more than welcome!.
>>> >
>>> > Specifically for the WARN, does this approach makes sense?
>>> >
>>> > https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com
>>> 
>>> (Sorry for missing this dicsussion back in December)
>>> 
>>> It probably does but the patch just introduces
>>> HV_TSC_PAGE_UPDATE_REQUIRED flag and drops kvm_write_guest() completely,
>>> the flag is never reset and nothing ever gets written to guest's
>>> memory. I suppose you've forgotten to commit a hunk :-)
>>
>> I don't think so, the idea is that kvm_hv_setup_tsc_page() handles the write.
>>

...

>
> but I'll have to refresh my memory on the problematic migration scenario
> when kvm_hv_invalidate_tsc_page() got introduced.

I've smoke-tested your patch with both selftests and Win10+WSL2
migration and nothing blew up. I, however, don't quite like the idea to
make HV_TSC_PAGE_UPDATE_REQUIRED a bit flag which is orthogonal to all
other HV_TSC_PAGE_ state machine states. E.g. we have the following in
get_time_ref_counter():

  if (hv->hv_tsc_page_status != HV_TSC_PAGE_SET)
          return div_u64(get_kvmclock_ns(kvm), 100);

the following in tsc_page_update_unsafe():

  return (hv->hv_tsc_page_status != HV_TSC_PAGE_GUEST_CHANGED) &&
          hv->hv_tsc_emulation_control;

and the followin in what's now kvm_hv_request_tsc_page_update():

  if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
      hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
      tsc_page_update_unsafe(hv))
          goto out_unlock;

and while I don't see how HV_TSC_PAGE_UPDATE_REQUIRED breaks any of
these, it cetainly takes an extra effort to understand these checks as
we're now comparing something more than just a state machine's state.
Same goes to all assignments to hv->hv_tsc_page_status:
HV_TSC_PAGE_UPDATE_REQUIRED gets implicitly overwritten (i.e. we're not
just switching from state A to state B, we're also clearing the
flag). Again, I don't see how is this incorrect, just unnecessary
complicated (and that's what get me confused when I said you're missing
something in your patch!). 

In case making HV_TSC_PAGE_UPDATE_REQUIRED a real state (or, actually,
several new states) is too cumbersome I'd suggest to explore two
options:
- adding helpers to set/check hv->hv_tsc_page_status and making
HV_TSC_PAGE_UPDATE_REQUIRED clearing/masking explicit.
- adding a boolean (e.g. "tsc_page_update_required") to 'struct kvm_hv'.

-- 
Vitaly

