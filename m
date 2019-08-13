Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61D68B263
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfHMI0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:26:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46170 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbfHMI0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:26:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so106923293wru.13
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 01:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xxqnQ+CnehHQ/Z2KjoSVBMjf9aqW8bf9s9y55Oqxpus=;
        b=Uoelka1fudgdSjTqQWY+2S5IvM4jFRvWySeww6cxbpK8+S+jyAmVZuwiaBV0QFG6WF
         oOjsJJvVK4SoiRGCJgRPi/6vAvcGA8zMaIDMfnA9uSX9Crcc4mk9fOYCt2JBNF7wqQEW
         2tY+GgKka3OdNU7vfhqz9r5JnCTZO9s8LRBREwo3C9P+rxFH90lF8q6QELs31PYG5BM8
         Bl8qWet6aeWsFaxjv6AjFXfWWxhkBPRbno3tXXZXuXY7LmmdL1socOoAjvO6AxqbDV2c
         LFAv1Nz4pZtAtwQia/sSPlnSkAloMPyT8PuMXOOdrrp+8iU4beOjAuOTeEY7Z0rV1bnm
         aj0g==
X-Gm-Message-State: APjAAAUMYKPXiV4crWl/YHsdudmEobhBq64uUdTdlxrILCzoCeSESPK5
        xRqKJkPNmxe9fwp8PsocoBXo7Q==
X-Google-Smtp-Source: APXvYqz4uFItaxiCcQv78nTDKp0pJqOC6D9k/pJKcDrE7Ren7xe2XjGO7pxUM1GtjA16i5a4LjG6iw==
X-Received: by 2002:adf:dec8:: with SMTP id i8mr3468071wrn.217.1565684792723;
        Tue, 13 Aug 2019 01:26:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id y7sm595385wmm.19.2019.08.13.01.26.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:26:32 -0700 (PDT)
Subject: Re: [RFC PATCH v6 14/92] kvm: introspection: handle introspection
 commands before returning to guest
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-15-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <645d86f5-67f6-f5d3-3fbb-5ee9898a7ef8@redhat.com>
Date:   Tue, 13 Aug 2019 10:26:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-15-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> +			prepare_to_swait_exclusive(&vcpu->wq, &wait,
> +						   TASK_INTERRUPTIBLE);
> +
> +			if (kvm_vcpu_check_block(vcpu) < 0)
> +				break;
> +
> +			waited = true;
> +			schedule();
> +
> +			if (kvm_check_request(KVM_REQ_INTROSPECTION, vcpu)) {
> +				do_kvmi_work = true;
> +				break;
> +			}
> +		}
>  
> -		waited = true;
> -		schedule();
> +		finish_swait(&vcpu->wq, &wait);
> +
> +		if (do_kvmi_work)
> +			kvmi_handle_requests(vcpu);
> +		else
> +			break;
>  	}

Is this needed?  Or can it just go back to KVM_RUN and handle
KVM_REQ_INTROSPECTION there (in which case it would be basically
premature optimization)?

Paolo
