Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6584F9A8E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiDHQ0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiDHQ0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEB2212C6EE
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649435050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNM3e13FuXjpOTxfKn23ludDa/hElwvCWDA3XWMySmQ=;
        b=eGfVqZFJOLGcwfbli5m3/07nozFaq9BYvEPz0XaebZoUq9zslkM1zCWLFBo56xvr0FwTMh
        wPNEGb9uGZGXb+Z5xpQ+KB+su8dcNW+x/h4MhQgmKXRXkdy5VEus4Vdq06DuhbM7mJg8Cp
        VB5kCbWRWxPfqn13RV0oJ9CtYYnanAU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-Zsom1hscMfWUx94iE_bnqw-1; Fri, 08 Apr 2022 12:24:08 -0400
X-MC-Unique: Zsom1hscMfWUx94iE_bnqw-1
Received: by mail-wr1-f70.google.com with SMTP id s13-20020adfa28d000000b00205e049cff2so2378832wra.17
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 09:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WNM3e13FuXjpOTxfKn23ludDa/hElwvCWDA3XWMySmQ=;
        b=p7jAVSf5GHH8TclPsBQDwhc2s4Q9boWdEnFDrERV7ibiLJUMuV5Q89EmEOuCDdILTq
         vCBHs5zRnrR2cSCsfCRzYa6WktoTS92BcPsjZSKgQI31rcIpAZHUlIVDwv355IZMk86i
         0VDKelKzqZRJWvYMSdUho5fR6iwsUiQqxYvBU6uoivpqHOappkmZWgygJZOVtUjM9Hm2
         DW+KiPtqLegc5LWBm7XozLtaP5w9svidUcA1q53mAhGA0OEtluqZ9dDlj04+lSMpH2uN
         Y/JLTAuCP9Mxn/zW9Kbxga5zpBPBLcbYwKkkGMsV0BPT6mosGosSEV8TcbZw9e4tAzoG
         jVcA==
X-Gm-Message-State: AOAM5309nNRhkkU1H5VDxtHPSK3+0EEdObi2tC3lF8IAILi3EmcW/BuE
        eJ9UEewsNXgRJlPdXirMRm0dFcpxprgD5TEvNxYv9jnm6EdFSGu+VGUGy7TPGFlexGyeKDr1iT/
        wU2gW/n5aTzfA
X-Received: by 2002:adf:eb88:0:b0:205:e113:dcb5 with SMTP id t8-20020adfeb88000000b00205e113dcb5mr15157606wrn.598.1649435047338;
        Fri, 08 Apr 2022 09:24:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSxPKbVuvV53Om6MJ+HAp3TS7BkfNNmVWZgz1Pz7A94FNoiFZRaEs/aLh1XXt0q8y0d21VhA==
X-Received: by 2002:adf:eb88:0:b0:205:e113:dcb5 with SMTP id t8-20020adfeb88000000b00205e113dcb5mr15157592wrn.598.1649435047094;
        Fri, 08 Apr 2022 09:24:07 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm16631476wmq.27.2022.04.08.09.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 09:24:06 -0700 (PDT)
Message-ID: <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com>
Date:   Fri, 8 Apr 2022 18:24:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Unexport of kvm_x86_ops vs tracer modules
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, rostedt <rostedt@goodmis.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Michael Jeanson <mjeanson@efficios.com>
References: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 17:36, Mathieu Desnoyers wrote:
> LTTng is an out of tree kernel module, which currently relies on the export.
> Indeed, arch/x86/kvm/x86.c exports a set of tracepoints to kernel modules, e.g.:
> 
> EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry)
> 
> But any probe implementation hooking on that tracepoint would need kvm_x86_ops
> to translate the struct kvm_vcpu * into meaningful tracing data.
> 
> I could work-around this on my side in ugly ways, but I would like to discuss
> how kernel module tracers are expected to implement kvm events probes without
> the kvm_x86_ops symbol ?

The conversion is done in the TP_fast_assign snippets, which are part of 
kvm.ko and therefore do not need the export.  As I understand it, the 
issue is that LTTng cannot use the TP_fast_assign snippets, because they 
are embedded in the trace_event_raw_event_* symbols?

We cannot do the extraction before calling trace_kvm_exit, because it's 
expensive.

Paolo

