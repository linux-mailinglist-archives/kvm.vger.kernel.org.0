Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5680669AC3
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfGOS0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:26:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39045 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729488AbfGOS0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:26:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so5810585wmc.4
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:26:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3r4P0+M7ImAyvre98SNFzf8jhlIWOt2YSnU5mtBDaVo=;
        b=RfPjL1VQV7H9v6me32B9HPp4CBW1Xr6nt6UnRViK5qZnoxD+eURwpGOntmIzBtjAc/
         p6pD8hdpnSFMaohqncn98bvapj+lcizIKZBwKftk9ZEhbsxSwId5Bh28ayfdHnvAEkXM
         M3GWFs4gJfs4n+ulrWtqXYo/AVLnX4AgAz9RKVppIbcApPItb/IcPHo9IcXRmdO2csms
         ttAxh6OyH4zfeI1xXi8ci+vB6NJ1hNzOz6KsOmHz+fKUo87HnvVUJcyP7iv1avcJoJB1
         Mh67UClH4n2YA6GhOhtQVItxawjbBpH0YCFZjcZjQwNLGWjisX/SXSXuhprd6Vv3IKOP
         AaWA==
X-Gm-Message-State: APjAAAXg0G+Z//zxLQuNdCS4KTRzD6SKsGINSgjpWTHe9ln1HoGccvFI
        zki87Pu9212leIjcHXZydV+Zt2xT9pE=
X-Google-Smtp-Source: APXvYqz4U72gYi8qwSducod2vblxO6f+aebELQMXImS7XT0CfkS0M+QI1vdKHczqa2LeXLDspivA2w==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr25271936wmg.135.1563215168692;
        Mon, 15 Jul 2019 11:26:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b159:8d52:3041:ae0d? ([2001:b07:6468:f312:b159:8d52:3041:ae0d])
        by smtp.gmail.com with ESMTPSA id u186sm28771212wmu.26.2019.07.15.11.26.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:26:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
 <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ab5e8e73-5214-e455-950d-e837979bb536@redhat.com>
Date:   Mon, 15 Jul 2019 20:26:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 20:08, Nadav Amit wrote:
>> On Jul 15, 2019, at 8:48 AM, Andrew Jones <drjones@redhat.com> wrote:
>>
>> On Fri, Jun 28, 2019 at 01:30:19PM -0700, Nadav Amit wrote:
>>> Enable to run the tests when test-device is not present (e.g.,
>>> bare-metal). Users can provide the number of CPUs and ram size through
>>> kernel parameters.
>>
>> Can you provide multiboot a pointer to an initrd (text file) with
>> environment variables listed instead? Because this works
>>
>> $ cat x86/params.c 
>> #include <libcflat.h>
>> int main(void)
>> {
>>    printf("nr_cpus=%ld\n", atol(getenv("NR_CPUS")));
>>    printf("memsize=%ld\n", atol(getenv("MEMSIZE")));
>>    return 0;
>> }
>>
>> $ cat params.initrd 
>> NR_CPUS=2
>> MEMSIZE=256
>>
>> $ qemu-system-x86_64 -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel x86/params.flat -initrd params.initrd
>> enabling apic
>> enabling apic
>> nr_cpus=2
>> memsize=256
>>
>>
>> This works because setup_multiboot() looks for an initrd, and then,
>> if present, it gets interpreted as a list of environment variables
>> which become the unit tests **envp.
> 
> Looks like a nice solution, but Paolo preferred to see if this information
> can be extracted from e810 and ACPI MADT. Paolo?

It was mostly a matter of requiring adjustments in the tests.  Andrew's
solution would be fine!

Paolo

