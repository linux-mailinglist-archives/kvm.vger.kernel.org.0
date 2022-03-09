Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A866B4D3925
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 19:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiCISsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 13:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbiCISsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 13:48:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB4D8C73
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 10:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646851638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3nc17BUtz+qPmTypFBvwUPQaSTBnMDANsUTpV88wwo=;
        b=XdOxSVZTHvYZUZUlFlXKn8DlyTdx+x6xBvzCEYcuiOoUEcmChfiR3KguqqapJ7A7bNSCni
        caBa08he3GiV0eab7lBby3oXpd/e9UzKuqZ/VyKHslO6sckXpwLYBaWuR4prBZf/1CCFSl
        9W8c2xWJ1h5ed+sTa3oFYOpuJXOkLzE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588--36Y5VojPQ-MC5Yz6s_xkA-1; Wed, 09 Mar 2022 13:47:16 -0500
X-MC-Unique: -36Y5VojPQ-MC5Yz6s_xkA-1
Received: by mail-wr1-f70.google.com with SMTP id h11-20020a5d430b000000b001f01a35a86fso1044991wrq.4
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 10:47:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v3nc17BUtz+qPmTypFBvwUPQaSTBnMDANsUTpV88wwo=;
        b=xmbhdo7Hqn8sUPrqJpQr0ny9lcIwzVzYG7lW2MnUvfYDaoBvq4HPId4tkhBsuXDpy5
         tKRO9kIQ43x5AH+OOw3gK8/EkhZxyvZBYJUxr5kAyeYpam4+2YXDAzNb0n9uUvt5AuLn
         1+3Wvec+pXc3JnHLAPV2xZWrX3w86h5byn2B4vmjeDkw9dmHIQ3NfqGl5wO/jFDIgnLq
         bCHQ61dQD3SwsXyx5/+xAppwtCgMju+0SfMFFdBnjEDx8HoJbSNb/LEceW2FfZ/cIdYM
         kd25Le+qCkzNTZCmdEt4uW5qAMzAJQGwfgQX25vAEQSyR9iY9lzpixMiayrw++f8L8w9
         Ge7Q==
X-Gm-Message-State: AOAM531iQmCY4d1AwGTkYObXmxKx6S1YRPidmoLd8PmvqjDVBJ3chS7c
        aWeLGrkk8A29uHvp/rO4qo5MDY9JTIbXXXujns/AxEM/7JtHRzaqxuAA6iFq8bx/dnmR+x2uz4N
        dhufKx/j1Cc9e
X-Received: by 2002:a05:6000:1a52:b0:1f0:2d62:2bbb with SMTP id t18-20020a0560001a5200b001f02d622bbbmr769992wry.614.1646851635672;
        Wed, 09 Mar 2022 10:47:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9OJCzl0unpcmM0QiwDwLYC4TXVttgEnD6Q8PEWAqXMM5Vs4LdirN5xhBqiLXAVn8NCdOCSA==
X-Received: by 2002:a05:6000:1a52:b0:1f0:2d62:2bbb with SMTP id t18-20020a0560001a5200b001f02d622bbbmr769967wry.614.1646851635462;
        Wed, 09 Mar 2022 10:47:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id n17-20020a05600c3b9100b00389d6331f93sm989468wms.3.2022.03.09.10.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 10:47:14 -0800 (PST)
Message-ID: <6a7f13d1-ed00-b4a6-c39b-dd8ba189d639@redhat.com>
Date:   Wed, 9 Mar 2022 19:47:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold and
 count when cpu_pm=on
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
 <20220301143650.143749-5-mlevitsk@redhat.com>
 <CALMp9eRjY6sX0OEBeYw4RsQKSjKvXKWOqRe=GVoQnmjy6D8deg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRjY6sX0OEBeYw4RsQKSjKvXKWOqRe=GVoQnmjy6D8deg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 19:35, Jim Mattson wrote:
> I didn't think pause filtering was virtualizable, since the value of
> the internal counter isn't exposed on VM-exit.
> 
> On bare metal, for instance, assuming the hypervisor doesn't intercept
> CPUID, the following code would quickly trigger a PAUSE #VMEXIT with
> the filter count set to 2.
> 
> 1:
> pause
> cpuid
> jmp 1
> 
> Since L0 intercepts CPUID, however, L2 will exit to L0 on each loop
> iteration, and when L0 resumes L2, the internal counter will be set to
> 2 again. L1 will never see a PAUSE #VMEXIT.
> 
> How do you handle this?
> 

I would expect that the same would happen on an SMI or a host interrupt.

	1:
	pause
	outl al, 0xb2
	jmp 1

In general a PAUSE vmexit will mostly benefit the VM that is pausing, so 
having a partial implementation would be better than disabling it 
altogether.

Paolo

