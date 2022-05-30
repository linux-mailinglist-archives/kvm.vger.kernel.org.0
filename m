Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965F1537847
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiE3JPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiE3JPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:15:32 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BE679391
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 02:15:29 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r65so8218707oia.9
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 02:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=JMYsR2Kv//YaZ7QShXeZBhZQwYsMq/3jlmc79DNtU6I=;
        b=r5usHSRYiwNNYTwmkD2OFG3o4xlTabCtnLviftTDB2lrQxLpTOfnMLrGRx+VJYP0Ra
         dkBXSu//8oTVuZvlzjYBFxSLrlzQTBicM9yLtF6ZlsISIVYG+jh2siYnEjNYAgPg1QH4
         G9882CBZYFtekWWqDMaXffH6bHKaF/OVcV/wQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JMYsR2Kv//YaZ7QShXeZBhZQwYsMq/3jlmc79DNtU6I=;
        b=7jDWciPkEetMYlxMTRQve0NnGNZasM9MZ+i/MBL6M1DhOU8YT+eaZn+nD45G5lE+/X
         bMCpPkhOOVJHtoinuL3xfrr7A+wz2agzWK3pjW6HM8mrViVIkQzNmvfWmsgEianwoIzi
         Y9J3/S8gd6OQkFU3sVkGpQMSvZrau/h+iQDTbM/VWdpXXoCTj2fBXkwVVANfygR42imw
         F/qcXJ1nH0lZ5TLJmuRb6TzjFA3TfqdW/0YGgEld5DB46WF+zlquzkjTQe7CmPWhy02o
         TZDtmOjls4sLVR4xzzlFFugngTTUSHOjllC7N/OG6u5gP8R5RyvEpd7c5L4L+wrLz7w+
         /O1g==
X-Gm-Message-State: AOAM533YEsfvahIMLw6hm+6SSd4SvZwBefHvu/2+JcT1jUwwz4PuxcjG
        UQmN/u0cShdFsFxl/7nl43QwB0HlUiAQbFg/zAKd1Z54QZ0=
X-Google-Smtp-Source: ABdhPJwVaJTrWGMMIAYb7bwD+kQVwSv5HXtRyOFuq0eTm8607qQGuhBKXAXbELFOQbgRlqJM8cjGjb0uXDZnLbo+yc8=
X-Received: by 2002:a05:6808:1288:b0:32b:9b72:e9b2 with SMTP id
 a8-20020a056808128800b0032b9b72e9b2mr9450101oiw.37.1653902128840; Mon, 30 May
 2022 02:15:28 -0700 (PDT)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Mon, 30 May 2022 14:45:17 +0530
Message-ID: <CAJGDS+Ep4NVQtPT5p4jwciYOQW=yiw=pHd9+FJ7gQC6aSMu4sg@mail.gmail.com>
Subject: Discrepancy in vmexits due to kprobe #BP in a KVM environment
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

Thank you for answering my previous question where I had tried to
cause a VMEXIT as a result of #BP interrupts arising out of a kprobe
hit.

I am now able to record VMEXITs of type KVM_EXIT_DEBUG and I also see
that the userspace program (QEMU) is automatically taking care of
injecting the #BP into the guest. I do not update the RIP any more. As
a result of this, the guest execution continues successfully.

I am now trying to set kretprobes and trying to record KVM_EXIT_DEBUG
again. I am having trouble reliably getting the VMEXITs. For example,
if I set a return probe on the function "native_safe_halt", I seem to
get VMEXITs of type KVM_EXIT_DEBUG reliably continuously. If I try to
set a return probe on the function "unix_stream_read_generic" however,
I get VMEXITs right at the time the kernel module is loaded, after
which the VMEXITs stop coming altogether. The same observation is seen
when I set a kretprobe on the function "free_one_page" or
"free_compound_page". Why is this behavior so unpredictable?

It seems like some of these VMEXIT events are "caught by a lock" and
they are released only when the kernel module is loaded/unloaded.

I am using the kretprobe example from a read-only repository on Github
(spotify/linux).

Why do VMEXITs stop coming and how is it dependent on the probed
function? Can the behavior of return probes change depending on the
function being probed?

Thank you very much.

Best Regards,
Arnabjyoti Kalita
