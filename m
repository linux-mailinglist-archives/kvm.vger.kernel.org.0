Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A20E14407E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 16:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgAUP2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 10:28:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51782 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727508AbgAUP2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 10:28:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579620521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHCZsRvQttcw8XgkTQh99Ct42XqmYq4StjtF6QwKxoc=;
        b=T0gvoQrj2mHeJUnbM5xl52laOiquJ24LmI9KgNQgIuah1kNbAQVdYk4n8W5LjVB+X/C50J
        kNjmBQBTCbBdHeA0Z9oE3Db0AFKNGpMrCqp5c6WcLtgfNGcKI0fULO+/kedG2qlcIhrn/p
        TO7vlAT43HraV+HfHmMhyXN7VQtzS0Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-jcp_SHWlOnWdSluxd0b68Q-1; Tue, 21 Jan 2020 10:28:40 -0500
X-MC-Unique: jcp_SHWlOnWdSluxd0b68Q-1
Received: by mail-wr1-f70.google.com with SMTP id r2so1457619wrp.7
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 07:28:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SHCZsRvQttcw8XgkTQh99Ct42XqmYq4StjtF6QwKxoc=;
        b=g1HDpoz2f+1A/3LPBJcJFSqtkwnmZ/j5MhKSgEBLViJxo/Ci3AI4Eqnr4HQutV9OWv
         YxC8BshA5e8vHDLHabmrHUEGLh+RwDCjEavi1Fh/7urkO5+toXwkQjZ56fNJWEGwr06N
         gi6MclQqZWgybpjyC91GzNNP5S/5AF0e9qPzKGqek85fYReBlk42L2XVwx2TBYwbc0F5
         2344beoOG+OWK0myGsj1YX6XnwtW4hyPskNGQALJAtNnjcRW0JpBy+KHBJuY6QC8+KDM
         esQrDhIMgAL98kv8spPZuDXstDvDBZEBQ/1WCaLBwvgoktJQb+5Iy9tJsmYwj8vdan5o
         FvZA==
X-Gm-Message-State: APjAAAVVxzoa/7nmIVnDVjJMeaLiudNko8yz6Gwof2/ItdCYx6hJvuso
        HRB1+IjmTaN+w9Yech45oOPGFjFUHmdTm9RfKyGV6foHzVsN+kWJUxGVwMlEV8BI1taXNzB7Rwv
        QSbxNa9rZUp7D
X-Received: by 2002:a5d:494b:: with SMTP id r11mr5779952wrs.184.1579620518755;
        Tue, 21 Jan 2020 07:28:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqx822hIl7/7gYrCFnOYKsHrSSH86F2HvIZKXHH8DNrhdRU+SRL5EutNges8vGhbNi+m2vJRyg==
X-Received: by 2002:a5d:494b:: with SMTP id r11mr5779930wrs.184.1579620518451;
        Tue, 21 Jan 2020 07:28:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id a14sm56577192wrx.81.2020.01.21.07.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 07:28:37 -0800 (PST)
Subject: Re: [PATCH 2/3] KVM: x86: Emulate MTF when performing instruction
 emulation
To:     Oliver Upton <oupton@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200113221053.22053-1-oupton@google.com>
 <20200113221053.22053-3-oupton@google.com>
 <20200114000517.GC14928@linux.intel.com> <20200115225154.GA63061@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41f2f408-bc3e-b28a-7645-8b9b6939ecf6@redhat.com>
Date:   Tue, 21 Jan 2020 16:28:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200115225154.GA63061@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/20 23:51, Oliver Upton wrote:
> Good point. I'm instead inclined to call the hook to emulation_complete
> (will rename as appropriate) from kvm_vcpu_do_singlestep(), as it
> appears this is how x86_emulate_instruction processes the trap flag.
> Need to take a deeper look + test to ensure this change will fix MTF for
> full instruction emulation.

Cool, I was going to suggest the same.  You can use the forced emulation
prefix to send your testcase down the x86_emulate_instruction path.

Paolo

