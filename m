Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E27376BF6
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 00:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhEGWBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 18:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhEGWBc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 18:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620424831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+2l+yILKTmVXAtWg5GIkfQ0owvNFPiGBYpccXtbsjOg=;
        b=RJuobfMwuXcXX34M5ViFOscCAh8sG9Cr62bDDOrfeuYMx/tGlfwXyEL6i/ep8iB5JC0G+c
        v4UQZlzvaa5aL/nV46x3XMZY4A2fjK9fQbNNMtJ9+KsAQxc/u1v6WhCAyraeJmFclcUJjh
        aWjPF97GK9gLM7YRHaWArGb0wP7CTqA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-3qgDcSwuOSqpfnUgB6XM4A-1; Fri, 07 May 2021 18:00:29 -0400
X-MC-Unique: 3qgDcSwuOSqpfnUgB6XM4A-1
Received: by mail-oi1-f198.google.com with SMTP id r20-20020a0568080ab4b0290186e76a5ddaso5044977oij.21
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 15:00:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+2l+yILKTmVXAtWg5GIkfQ0owvNFPiGBYpccXtbsjOg=;
        b=RLMiVKoTnmqfI0O1/ko0cnqFXBjJ0kggK2inETAIosztQpSg2HTPIsQzEghuU7MoKh
         DaNGAb4KGhdj4PlmyOb9PSEBPKDjtTeDMIbBK0V3K1IjOLyJ6a59sQzjIE746m9kWVsm
         wFIsCyV6FLBo+ZoJ6CdkvfuYK7ffuHkhhQWMFE3o0CEEme6tvMn3l2HCQAs7o5JKclsO
         FFDk+nHa4npA74wdjIK00BqDNBrdSG2SyUEYDAZExHRmlp/WC0P4RRUaLDqL4e8faFD8
         hge3jOmc5smJDHuwtjL6pAPp5ilM4MX8JGpLRzLM/Y72LMSQvy+906NfCTELm4svFV8T
         OTlA==
X-Gm-Message-State: AOAM530Ob5MTH3avqELoDZdMCi0HE8bfufy0qVKudBiXw+2nBqXuZx1B
        D9BfLXMFK6NZ7kP8nALCCgSDTx/+gwCRy6HjEFuy2aHqAjVMNrXvQzcWwiGtfH69TFpIVBqXUXc
        Mu8x93hzelbdVnqsLj3W8YbEcJM6bzWZ5nAd9C8eR7vD4DDyFwvNQs6Ft1aMreg==
X-Received: by 2002:a05:6830:410e:: with SMTP id w14mr10347946ott.251.1620424828806;
        Fri, 07 May 2021 15:00:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwHJq/Lo10V2TsKqgNvfJloU+un87SEsPkv1RYQNIPii+V71dQ/VupeZR7Yxt1L26nTBGZag==
X-Received: by 2002:a05:6830:410e:: with SMTP id w14mr10347923ott.251.1620424828531;
        Fri, 07 May 2021 15:00:28 -0700 (PDT)
Received: from [192.168.0.112] (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id q26sm1509837otn.0.2021.05.07.15.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 15:00:28 -0700 (PDT)
Subject: Re: [PATCH v3] target/i386/sev: add support to query the attestation
 report
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     armbru@redhat.com, dgilbert@redhat.com,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210429170728.24322-1-brijesh.singh@amd.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <dd711e32-c4bb-ca8f-5892-0133098e632e@redhat.com>
Date:   Fri, 7 May 2021 17:00:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210429170728.24322-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/21 12:07 PM, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> 
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
> command the ATTESATION_REPORT command can be called while the guest

typo: 'ATTESATION_REPORT'

> is running.
> 
> Add a QMP interface "query-sev-attestation-report" that can be used
> to get the report encoded in base64.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Reviewed-by: James Bottomley <jejb@linux.ibm.com>
> Tested-by: James Bottomley <jejb@linux.ibm.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Looks good to me!

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

