Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA45D6CFD8D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjC3IAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjC3IAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77A359FA
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680163176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxFt0FdXZm/lNNkRaUGfjB4xCCRrtMpzebxxVMuXjMY=;
        b=Yp9Y/IHa5a8hpfzmbdW1ukyeXN4ewZz19oV32SaTc7zkAvcyR9O8ZVKMktKoHkti+lgquR
        jGkcI9UYZsLodosLZeWkrAtryq7W3ksEVTjZY6WxDeyTpO1gFfcNTArHkzWwZttc1L6PP9
        jna4OjKUzQXEDWfShAlMfJKeRSA6kq4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-ZbzpNzBwNze1RFI6dng2qw-1; Thu, 30 Mar 2023 03:59:35 -0400
X-MC-Unique: ZbzpNzBwNze1RFI6dng2qw-1
Received: by mail-qk1-f200.google.com with SMTP id s21-20020a05620a0bd500b0074234f33f24so8419755qki.3
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680163175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gxFt0FdXZm/lNNkRaUGfjB4xCCRrtMpzebxxVMuXjMY=;
        b=6Bhm2xbyXCGQeka4Bc4mIrGw+w34otgHAd8dIqIoI5tc5LlrLLJ635Jp9Os8/FXjlg
         lFptjToV+NLrWPLoBB2GJveTmMji2UVQ73elwVc1SUcx7gRYVDGv2yiQjtdGaQG4lOKn
         ilgtSAhsWBd0Rvx+Q4RmtPZChK0BmbVn7nMWTHmAS/qecIn/yKzlZf7Z1CZL7RkP/wmI
         37aN+3yM305oh6OI6+kUh4XLiUgTtzJyhUtNryBbmnZAL4Xfl8OQ7WMyb3JUUdtVx1N6
         JBuKX6R0am8N/NfPqdGn7hiGvniQzxX2HQzRhVxVYp43xSsVGxh+uU7LB3YuFPvqGypu
         q8fw==
X-Gm-Message-State: AAQBX9eaFtHI7PdYyP/a8XlK0AQr7SGs6ZKf0C6lx80PssIO4vj14WPa
        BiT4VjfsK/TVOXkJxcckBcB/qDVnKSuT0ChGUKf00kH3wtVPxOTSahw9SOfKoC7qJXmDwlNhEzj
        LVVpIoY2I3Oxe
X-Received: by 2002:a05:6214:21e2:b0:5ac:fb9a:67a1 with SMTP id p2-20020a05621421e200b005acfb9a67a1mr35187279qvj.47.1680163174940;
        Thu, 30 Mar 2023 00:59:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350aeyvdcvUivmNyhEQwPGxNhJTEPdoEAzq1nypJx9LQC6TDe0nwpFlqmxF88b96ql3t1ZKOwlQ==
X-Received: by 2002:a05:6214:21e2:b0:5ac:fb9a:67a1 with SMTP id p2-20020a05621421e200b005acfb9a67a1mr35187263qvj.47.1680163174708;
        Thu, 30 Mar 2023 00:59:34 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id dm4-20020ad44e24000000b005dd8b934569sm5302558qvb.1.2023.03.30.00.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 00:59:34 -0700 (PDT)
Message-ID: <754c052c-b575-4abc-605a-fff7d09c4a65@redhat.com>
Date:   Thu, 30 Mar 2023 09:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: The "memory" test is failing in the kvm-unit-tests CI
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Cole Robinson <crobinso@redhat.com>
References: <0dcae003-d784-d4e6-93a2-d8cc9a1e3bc1@redhat.com>
 <ZCSNasVg+HBK0vI1@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <ZCSNasVg+HBK0vI1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/03/2023 21.11, Sean Christopherson wrote:
> On Wed, Mar 29, 2023, Thomas Huth wrote:
>>
>>   Hi,
>>
>> I noticed that in recent builds, the "memory" test started failing in the
>> kvm-unit-test CI. After doing some experiments, I think it might rather be
>> related to the environment than to a recent change in the k-u-t sources.
>>
>> It used to work fine with commit 2480430a here in January:
>>
>>   https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3613156199#L2873
>>
>> Now I've re-run the CI with the same commit 2480430a here and it is failing now:
>>
>>   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4022074711#L2733
> 
> Can you provide the logs from the failing test, and/or the build artifacts?  I
> tried, and failed, to find them on Gitlab.

Yes, that's still missing in the CI scripts ... I'll try to come up with a 
patch that provides the logs as artifacts.

Meanwhile, here's a run with a manual "cat logs/memory.log":

https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4029213352#L2726

Seems like these are the failing memory tests:

FAIL: clflushopt (ABSENT)
FAIL: clwb (ABSENT)

  Thomas


>> Does anybody have an idea what could be causing this regression? The build
>> in January used 7.0.0-12.fc37, the new build used 7.0.0-15.fc37, could that
>> be related? Or maybe a different kernel version?
> 
> Nothing jumps to mind.  Triaging this without at least the logs in going to be
> painful.
> 

