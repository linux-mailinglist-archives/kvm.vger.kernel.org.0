Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E84A1ADEB6
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbgDQNtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:49:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730731AbgDQNto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 09:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587131382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5V7yavyfZ0HM3zUpT1F2jPJ2A6hFO+XG3RXrFUzY6h4=;
        b=dX3pOeMsUwp1t3MjdByw1I4hgE9vG3eRED2fDp4TZ6bZA1nc8FxsLvvM6airpIYziHSzoD
        hMmI4yC3faTXgM4ftZOxMd5D53hnQ1vx3Pt6YntxPs8dSZickbChSdEDNCrbjKZzbEClJg
        2etq/HGo22kMpibbgdQm2YfMobXBVnI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-5PT3xlqlP92CPnRjox0fCw-1; Fri, 17 Apr 2020 09:49:41 -0400
X-MC-Unique: 5PT3xlqlP92CPnRjox0fCw-1
Received: by mail-ed1-f71.google.com with SMTP id p6so760746edy.22
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5V7yavyfZ0HM3zUpT1F2jPJ2A6hFO+XG3RXrFUzY6h4=;
        b=c7OQTJQpqZYCd4X6LNhcL9EaTuSVogH0XZ985wx2EBNt2aHuXowrQeoW93se7K6INM
         J165B/4DL5mqO0jG6fVVYDxgVA3VgXqhEp5SkMARQX3XdadYurMlRUAR5SnxBZvp6a8i
         +Ivg0wYihmbovmDqosnCt8EqdwilhhkhHB+yXRMx37q6z6sTx/G/vmk8g87m1HLXmOB0
         Ur1OA1kp9hiQx/u2r6kwWu1NkGBIRcTByNmD0gZc6e3JurObnrrB/lg9khDpUQUhXQPy
         YGCUBr8HRtJwEofqeJLRDoXyRpO9ligYkgmJKy/tqlsvCLcne17qCmp+8zExbx1CWhDS
         a4oA==
X-Gm-Message-State: AGi0PuYa3NzaVKLzCjBXnw1iUxVaepKdADC5ch/a/yRSSBBxSgRHTR/O
        NW5hz69YcqYGiiTMwwLIXGjCiqYGnk8pasuQzXfw4EwUhMjI5Olsj2y0yVS8kcNCrjEf/Ur+PP2
        AV1FY/Lhaaew7
X-Received: by 2002:a17:907:40f2:: with SMTP id no2mr3110754ejb.41.1587131379834;
        Fri, 17 Apr 2020 06:49:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypIWJG5ihBce3BBaxEtVPybUKWhCIqZt7Zp8ZUwDutTUNVZeNIkgEyc74VK1iOZ6HN3OeNFGkg==
X-Received: by 2002:a17:907:40f2:: with SMTP id no2mr3110739ejb.41.1587131379533;
        Fri, 17 Apr 2020 06:49:39 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id q1sm3420124ejf.42.2020.04.17.06.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 06:49:38 -0700 (PDT)
Subject: Re: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG
 accel
To:     Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-4-philmd@redhat.com>
 <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org>
 <CAFEAcA8K-njh=TyjS_4deD4wTjhqnc=t6SQB1DbKgWWS5rixSQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <5d9606c9-f812-f629-e03f-d72ddbce05ee@redhat.com>
Date:   Fri, 17 Apr 2020 15:49:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8K-njh=TyjS_4deD4wTjhqnc=t6SQB1DbKgWWS5rixSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:11 PM, Peter Maydell wrote:
> On Mon, 16 Mar 2020 at 19:36, Richard Henderson
> <richard.henderson@linaro.org> wrote:
>> I'm not 100% sure how the system regs function under kvm.
>>
>> If they are not used at all, then we should avoid them all en masse an not
>> piecemeal like this.
>>
>> If they are used for something, then we should keep them registered and change
>> the writefn like so:
>>
>> #ifdef CONFIG_TCG
>>      /* existing stuff */
>> #else
>>      /* Handled by hardware accelerator. */
>>      g_assert_not_reached();
>> #endif

I ended with that patch because dccvap_writefn() calls probe_read() 
which is an inlined call to probe_access(), which itself is only defined 
when using TCG. So with KVM either linking fails or I get:

target/arm/helper.c: In function ‘dccvap_writefn’:
target/arm/helper.c:6898:13: error: implicit declaration of function 
‘probe_read’;
      haddr = probe_read(env, vaddr, dline_size, mem_idx, GETPC());
              ^~~~~~~~~~

I'll use your suggestion which works for me:

-- >8 --
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -330,8 +330,20 @@ static inline void 
tlb_flush_by_mmuidx_all_cpus_synced(CPUState *cpu,
  {
  }
  #endif
+
+#ifdef CONFIG_TCG
  void *probe_access(CPUArchState *env, target_ulong addr, int size,
                     MMUAccessType access_type, int mmu_idx, uintptr_t 
retaddr);
+#else
+static inline void *probe_access(CPUArchState *env,
+                                 target_ulong addr, int size,
+                                 MMUAccessType access_type,
+                                 int mmu_idx, uintptr_t retaddr)
+{
+     /* Handled by hardware accelerator. */
+     g_assert_not_reached();
+}
+#endif /* CONFIG_TCG */

  static inline void *probe_write(CPUArchState *env, target_ulong addr, 
int size,
                                  int mmu_idx, uintptr_t retaddr)
---

> 
> (1) for those registers where we need to know the value within
> QEMU code (notably anything involved in VA-to-PA translation,
> as this is used by gdbstub accesses, etc, but sometimes we
> want other register values too): the sysreg struct is
> what lets us map from the KVM register to the field in the
> CPU struct when we do a sync of data to/from the kernel.
> 
> (2) for other registers, the sync lets us make the register
> visible as an r/o register in the gdbstub. (this is not
> very important, but it's nice)
> 
> (3) Either way, the sync works via the raw_read/raw_write
> accessors (this is a big part of what they're for), which are
> supposed to just stuff the data into/out of the underlying
> CPU struct field. (But watch out because we fall back to
> using the non-raw read/writefn if there's no raw version
> provided for a particular register.) If a regdef is marked
> as NO_RAW then it means there is no raw access and we don't
> sync the value.
> 
> (4) I think that in KVM mode we won't deliberately do
> non-raw accesses, and a quick grep through of the places
> that do 'readfn' accesses supports that.
> 
> thanks
> -- PMM
> 

