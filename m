Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4495E3E3273
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 02:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhHGA7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 20:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhHGA7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 20:59:52 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F026EC0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 17:59:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a8so19144623pjk.4
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 17:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5HyZHfS8AsBy90XkNLPe774IDKkn3JiMkd3PeFjVH38=;
        b=MJ1S085DR5XA13X7bAsyITgXfu4dTx3O8g0KeRsFJBLLVYFoCGkBdPCdIlepJHCMbG
         qITAgD31mYuPEghA2MzWqNntVShRpPmDkuw3I7kdKNZMb3Mq/4PcUS3vmxoe/MDTCloy
         oIo+ihyECgBxnmZWlMkwRCUrAAV7wmGrYPLztXmf00pcIqYYqSxFk9ZyC2dlQFzRTXng
         qhT0vz/98aheiW2ujBpzFSw7NYPjLkCyd8i4Uohp4ebrCKhMQ1yrzBiWY/CUwmZ4RfWh
         SrnIe8oh2hnPIDoaYNohQdrPp6f6xwSLMHQrpLH690fPdfUtRg4ZmQT9ZHwFeBeeWIvX
         aIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5HyZHfS8AsBy90XkNLPe774IDKkn3JiMkd3PeFjVH38=;
        b=Khssd3fTswFRovGjVJovAqDMuiq42Zic/xoqqK+2xYqc7/6LoP2kSgLuJF5ZJ/auCA
         aF7XmYFrJpIDcuWxQ6182hECC14spHRcm9pK5uTDnLB0a1ZyyZZGXd58go2icwU8dIn3
         FWkWHcOs8a5g3F805MNr5+gfT/tixTat2qabbvshfQb/sP1vaiZUy8bvbpHSDX/UgoVd
         Jvr20CHbRqZp7bbnRHeKksigLt8e18L323fKpifNpcgSwAfTFF1SS50iDrfG9HsCQFoA
         BrdO2SiND+g3i+wGmKjnjBTNxS+N51ROKVkeK+JPGdDx8hOWejQrvVOD7zCM67R/PBm2
         rymQ==
X-Gm-Message-State: AOAM532Vq4N9uzI0bz24vpzi8UOOCPwWR1d9Y7Gxkal7sApt/vE+k1Wv
        ug2TImTOzn2wYNr5pvu0PcXL4Q==
X-Google-Smtp-Source: ABdhPJx8YkCQw5Bxh0ffWbQ3C1WTQM8vAknR2uwesgVRQKvdoDW5JjioeBgQsKRfKc6U5Nk5c/vYgA==
X-Received: by 2002:aa7:8387:0:b029:395:a683:a0e6 with SMTP id u7-20020aa783870000b0290395a683a0e6mr13448620pfm.12.1628297974299;
        Fri, 06 Aug 2021 17:59:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g11sm717226pfo.166.2021.08.06.17.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 17:59:33 -0700 (PDT)
Date:   Sat, 7 Aug 2021 00:59:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: On emulation failure, convey the exit
 reason, etc. to userspace
Message-ID: <YQ3a8jb2+3dj/PlE@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-3-david.edmondson@oracle.com>
 <YQR52JRv8jgj+Dv8@google.com>
 <cunk0l4mhjc.fsf@oracle.com>
 <YQgkGwGkrleO7I2A@google.com>
 <cunbl6fn4l6.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cunbl6fn4l6.fsf@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, David Edmondson wrote:
> On Monday, 2021-08-02 at 16:58:03 GMT, Sean Christopherson wrote:
> 
> > On Mon, Aug 02, 2021, David Edmondson wrote:
> >> On Friday, 2021-07-30 at 22:14:48 GMT, Sean Christopherson wrote:
> >> When we add another flag (presuming that we do, because if not there was
> >> not much point in the flags) this will have to be restructured again. Is
> >> there an objection to the original style? (prime ndata=1, flags=0, OR in
> >> flags and adjust ndata as we go.)
> >
> > No objection, though if you OR in flags then you should truly _adjust_ ndata, not
> > set it, e.g.
> 
> My understanding of Aaron's intent is that this would not be the case.
> 
> That is, if we add another flag with payload and set that flag, we would
> still have space for the instruction stream in data[] even if
> KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is not set.

Hmm, I don't think we have to make that decision yet.  Userspace must check the
flag before consuming run->emulation_failure, so we haven't fully commited one
way or the other.

I believe the original thought was indeed to skip unused fields, but I don't think
that's actually the behavior we want for completely unrelated fields, i.e. flag
combinations that will _never_ be valid together.  The only reason to skip fields
would be to keep the offset of a particular field constant, so I think the rule
can be that if fields that can coexist but are controlled by different flags, they
must be in the same anonymous struct, but in general a union is ok.

It seems rather unlikely that we'll gain many more flags, but it would be really
unfortunate if we commit to skipping fields and then run out of space because of
that decision.

> Given that, we must *set* ndata each time we add in a flag

Technically we wouldn't have to (being more than a bit pedantic), we could keep
the same flow and just do the ndata_start bump outside of the OR path, e.g.

        /* Always include the flags as a 'data' entry. */
        ndata_start = 1;
        run->emulation_failure.flags = 0;

        /* Skip unused fields instead of overloading them when they're not used. */
        ndata_start += 2;
        if (insn_size) {
                run->emulation_failure.flags |=
                        KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
                run->emulation_failure.insn_size = insn_size;
                memset(run->emulation_failure.insn_bytes, 0x90,
                       sizeof(run->emulation_failure.insn_bytes));
                memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
        }

so that it's easier to understand the magic numbers used to adjust ndata_start.

But a better solution would be to have no magic numbers at all and set ndata_start
via sizeof(run->emulation_failure).  E.g.

	/*
	 * There's currently space for 13 entries, but 5 are used for the exit
	 * reason and info.  Restrict to 4 to reduce the maintenance burden
	 * when expanding kvm_run.emulation_failure in the future.
	 */
	if (WARN_ON_ONCE(ndata > 4))
		ndata = 4;

	ndata_start = sizeof(run->emulation_failure);
	memcpy(&run->internal.data[], info, ARRAY_SIZE(info));
	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data, ndata);

	run->internal.ndata = ndata_start + ARRAY_SIZE(info) + ndata;

Though I'd prefer we not skip fields, at least not yet, e.g. to condition userspace
to do the right thing if we decide to not skip when adding a second flag (if that
even ever happens).

> with the value being the extent of data[] used by the payload corresponding
> to that flag, and the flags must be considered in ascending order (or we
> remember a "max" along the way).
> 
> Dumping the arbitray debug data after the defined fields would require
> adjusting ndata, of course.
> 
> If this is not the case, and the flag indicated payloads are packed at
> the head of data[], then the current structure definition is misleading
> and we should perhaps revise it.

Ah, because there's no wrapping union.  I wouldn't object to something like this
to hint to userpace that the struct layout may not be purely additive in the
future.

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d9e4aabcb31a..6c79c1ce3703 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -402,8 +402,12 @@ struct kvm_run {
                        __u32 suberror;
                        __u32 ndata;
                        __u64 flags;
-                       __u8  insn_size;
-                       __u8  insn_bytes[15];
+                       union {
+                               struct {
+                                       __u8  insn_size;
+                                       __u8  insn_bytes[15];
+                               };
+                       };
                } emulation_failure;
                /* KVM_EXIT_OSI */
                struct {
