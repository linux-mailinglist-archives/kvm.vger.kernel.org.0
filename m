Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C71F5F0D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 02:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgFKAHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 20:07:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53886 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbgFKAHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 20:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591834029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bG1f0DEkS8GNLNtqNZirTqogQo8gFsAlps/puTKPgPA=;
        b=RwETkzaGEWJxjDgEdWGgAoCZc0mOPLTj52EsbkP4VcfFZM0VvCXKcad/CjCW/HaXVmivH6
        KXCjNMZ4sor9Vl8RoGHZ27ZNM+0aLB4bHJkk4xXYYd9tybcO2g94GCAelsMmharX1cgZ7r
        R33FEffCz1VXA5dbuHf2EfsghPTyfH0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-zO1R9LKaNV-5bPkg6mj-qg-1; Wed, 10 Jun 2020 20:07:07 -0400
X-MC-Unique: zO1R9LKaNV-5bPkg6mj-qg-1
Received: by mail-wr1-f69.google.com with SMTP id c14so1763678wrw.11
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 17:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bG1f0DEkS8GNLNtqNZirTqogQo8gFsAlps/puTKPgPA=;
        b=RI76/KQWrIZRW9E2aXFvS5TR+YdoG2AU4RDC5yn3VFjI2YVXDaE3JepB4pr6a2wZ15
         0uVnW2p5lMaRk/mff+AooWiO38I8s5zTeYX65FFajfTylYE6qACSUDgdlIFghFm93p7g
         XCZKOHiWbg2Ev9Jlas1EiQ+XkYkEVl060uyZ125Vsnchfayjo87JaT5/SPCCCpUZL/g0
         2lCrfAOTsOwwu35eyNOPxdoYi5IwH0pZlzTXQRUSRyNNA6iHw4DZ2nSIZKvxIkzNvluR
         T9/iVrW2BKvszJVcJ1sBtXqFcURPfFhGGMw9WEcNJp7n21CNR7Ds2Tq6u4Ald/JCah9e
         AYWw==
X-Gm-Message-State: AOAM5329pV4AYSaU7FI9tXTc7dibw5nN+60y3+RUkuOviNnAbCFfZa7Y
        jBhPvNFIUi/eUXHMBuM5wtCh7sQ20ZqNaVfM3Y1Zw761etReELut+WJW2J2e5CbO0VZgwlkIQ7a
        2dC+IK+TmaBAw
X-Received: by 2002:a1c:1d94:: with SMTP id d142mr5500419wmd.42.1591834026137;
        Wed, 10 Jun 2020 17:07:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyERZxGXMtunnFSc+m5agcYq7aVk8aBfHzDqaphsJnY9S7fHd1kWpGwVRoNb/LyjwtNx/2Xvg==
X-Received: by 2002:a1c:1d94:: with SMTP id d142mr5500407wmd.42.1591834025935;
        Wed, 10 Jun 2020 17:07:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id v28sm2194252wra.77.2020.06.10.17.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 17:07:05 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: async_pf: Cleanup kvm_setup_async_pf()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
References: <20200610175532.779793-1-vkuznets@redhat.com>
 <20200610181453.GC18790@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <42da32b0-6cb0-58e4-dbb0-484afbd48757@redhat.com>
Date:   Thu, 11 Jun 2020 02:07:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200610181453.GC18790@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/20 20:14, Sean Christopherson wrote:
>> -	/* setup delayed work */
>> +	/* Arch specific code should not do async PF in this case */
>> +	if (unlikely(kvm_is_error_hva(hva)))
> This feels like it should be changed to a WARN_ON_ONCE in a follow-up.
> With the WARN, the comment could probably be dropped.

I think a race is possible in principle where the memslots are changed
(for example) between s390's page fault handler and the gfn_to_hva call
in kvm_arch_setup_async_pf.

Queued both, thanks!

Paolo

