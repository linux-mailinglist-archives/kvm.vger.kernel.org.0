Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CEF1E78B2
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgE2Irz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:47:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgE2Irz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590742074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dMJc+r/r+0/7enCThmZTDSPXOVNgB1F7k3W87RQaDkY=;
        b=K/LNz0MDnv2wmjjkd/T3Huvvq09h7gJ9sHnbsYXdj3iMznOUeukGlRNs7VCkCamyvWczEU
        887ClHHusMY/GHq+ItjQ1Jkp6fI56nED77jCVT+jub9JrNg1npEyiQkUbgjAeeOEiKf+Ri
        fsrFQQdp4MO1//42dW7NT9d9S4MCJAY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-wojy-EQ5MPywavv7Md5Stw-1; Fri, 29 May 2020 04:47:52 -0400
X-MC-Unique: wojy-EQ5MPywavv7Md5Stw-1
Received: by mail-wr1-f70.google.com with SMTP id n6so763295wrv.6
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 01:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dMJc+r/r+0/7enCThmZTDSPXOVNgB1F7k3W87RQaDkY=;
        b=iazAj2WoIdnB/JcKAeMo7HrdbUYX6rUEX7D0oa+OQLAvIoDuWl8NY+0kMZZySg1grT
         xji988CLr0H4EggZbqLCB19jwCJ7RjctFSsPpuLT2A1bG/XqOMtmkNI0a/CHVdasPNQa
         PXexYHjhZDW9ACXuS9ptr2uAKe/sSjlS5237BxuMG4UxfbeuGwUJabZcG5OWyBceq/0W
         bwsLTuUy/qOn7dTVmVr/nnVZQTE7NGRVJmjSaYygZrKBT8O6uzfdLkmONhrVp/IRI/Ad
         GoXy7/66G23yUJDSqUsxI8BcBT6G2fth0SdPcsKA2KVuvf34WJtEJ3pwEAHynSKp0C2O
         XFzw==
X-Gm-Message-State: AOAM530E6EwQEx85FaCGGQ/IZLzxRmefHHI3LiWSiJxBYVb44hBGygLp
        TeIikvVOThkDhQ+PITJthXneDQzT4sCIts//rgMEtqjLa5VyzHaSuxYe/x1NrXoPxH1KsE3Su3S
        arBKRMj8mgZf5
X-Received: by 2002:a05:6000:100d:: with SMTP id a13mr7682061wrx.317.1590742071102;
        Fri, 29 May 2020 01:47:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtAKBA+DYtf8htNfnI9kbnY0IFz6CjGCCBOuaPsdJCF4MCwCL4AgBIy6MCwkP7CEX+VoOv8w==
X-Received: by 2002:a05:6000:100d:: with SMTP id a13mr7682050wrx.317.1590742070904;
        Fri, 29 May 2020 01:47:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id k21sm4729753wrd.24.2020.05.29.01.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 01:47:50 -0700 (PDT)
Subject: Re: [PATCH 05/28] KVM: nSVM: correctly inject INIT vmexits
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
 <20200526172308.111575-6-pbonzini@redhat.com>
 <a5331d80-b6ee-b111-c91b-a8723fd3da9b@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <25c0ab83-f7d7-44f9-b00f-59ecee0256dc@redhat.com>
Date:   Fri, 29 May 2020 10:47:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a5331d80-b6ee-b111-c91b-a8723fd3da9b@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 08:46, Krish Sadhukhan wrote:
>>
>> +static void nested_svm_init(struct vcpu_svm *svm)
> 
> Should this be named nested_svm_inject_init_vmexit in accordance with
> nested_svm_inject_exception_vmexit that you did in patch# 3 ?

There's also nested_svm_intr and nested_svm_nmi.  I'll rename all of
them, but it will be a follow up.

Paolo

