Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA36421869C
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgGHMA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:00:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33379 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbgGHMA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 08:00:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594209656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hmKCNmXWHhIbbQdWVp5s2pqNmp2UrKc3xUPz10fSo04=;
        b=DI/YnxSrK4sNtUATjPSxHj3tFW89waMFnOrZ9GTtFEL0a9J608sVfjrt7VPJ4wDd6EwmKU
        Kjd97UmOjtI0VdZN04ErDSuiTg9hHT1shXDpqZLKzGaD4DwLHzLH12Aw7VK0qji54BUGYS
        RyeTC5pdwl6lTi+qHp+NrklTvFjcAeE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-6fjAW1j_MkWazbe9jqNdQw-1; Wed, 08 Jul 2020 08:00:53 -0400
X-MC-Unique: 6fjAW1j_MkWazbe9jqNdQw-1
Received: by mail-wm1-f71.google.com with SMTP id 65so2669402wmd.8
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 05:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hmKCNmXWHhIbbQdWVp5s2pqNmp2UrKc3xUPz10fSo04=;
        b=qwatDt9Wj5hLSNLwtHJI6/TM+s3C7i3SJ3Z303++u8S1Ojxwxsn9V1wXitxIm+JOwn
         8GTN0XQxfXLAqQ0fKs8V3Ia3GfsAyk7MRfKiaDveDzxpsaN2gD8xAyrZCvc6Yaw0ICiO
         lzS2a4CIFBINsxPUuaI8Ro2eu+e1aNwMkq/+2DUsBwbOFvx3xI0/+kejp0tokClpL8C+
         6o53SjnHYn4QLrsxlvQ069nEJzMdyZNUyY9KPwx2cdUshB+uJyyY/QZKsJw0XCnbGuFc
         P4axojc0zV/QWhHNID+xHxO7VMT4xOjDu+tYASp9LOEvxT8RaS9OtVcoKl6/+LafW1mQ
         iJMg==
X-Gm-Message-State: AOAM533+U9VVku6yTkJ+BpWY29jhJkJGwU6HPrN54sFKqTKTmJtCaBND
        Qat7+c2sLqFnIvzBICPkT7XNfTJ6h3qCOW4uO0u9a8mQ4K7+Ljv2kmfvYG6yOhZDu4GMQ3uwZGv
        rWgD55NhlxLKa
X-Received: by 2002:a7b:c116:: with SMTP id w22mr8656735wmi.97.1594209652202;
        Wed, 08 Jul 2020 05:00:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgDZMDB93ZlhsJ1XHsTJ4kZPxli+b1em/HHGjRGIBMn+xiyVQ/u5J5G/Zj7RI/Q8hS/gq2xQ==
X-Received: by 2002:a7b:c116:: with SMTP id w22mr8656716wmi.97.1594209651993;
        Wed, 08 Jul 2020 05:00:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id k126sm6226407wme.17.2020.07.08.05.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 05:00:51 -0700 (PDT)
Subject: Re: [PATCH v3 1/8] KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if
 SET_CPUID* fails
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
 <20200708065054.19713-2-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe0c23e6-491b-358b-8e94-94fb01cb3890@redhat.com>
Date:   Wed, 8 Jul 2020 14:00:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708065054.19713-2-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 08:50, Xiaoyao Li wrote:
> +Note, when this IOCTL fails, KVM gives no guarantees that previous valid CPUID
> +configuration (if there is) is not corrupted. Userspace can get a copy of valid
> +CPUID configuration through KVM_GET_CPUID2 in case.
> +
>  ::

I assume you mean "of the resulting CPUID configuration".

Paolo

