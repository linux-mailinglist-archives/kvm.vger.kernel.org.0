Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A109B1ADE3B
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgDQNYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730370AbgDQNYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 09:24:24 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB944C061A0C;
        Fri, 17 Apr 2020 06:24:23 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 37so826449qvc.8;
        Fri, 17 Apr 2020 06:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LjM566RamS9cOGWi1oxYwh/ACQIKEmK0YYeGg7bBlg8=;
        b=pRqHePFwms07Ep6/ib6PkjuPQOJQ3DvkMtRB9HOFtRu66Fsni+0tc4XkSdDe+I3gQB
         YW82FpBCJTp0PJqMAtjhUBy8QTCWUylgnaNrzKJRdK1hFZ93rt/7A11PoU970JFMj7PL
         oyvDFop46+tF8T50i45Ua+i0bkvVwLErgROVjyIc6j3SVnzCEjBLhRxMmBYD1w6BT8mM
         c6W4yRI84puErJpG+0mYVwQzeQH2OsiZs4zwS8+s17ttqKwBfBnd+dNwxAXCS6dpKtAh
         Vk+W/9KKlFKO0e9V/WrBY4bM8/Bd87N4lsqy3Ckwq8IuEwe8VGbztgU+rtND/Nv2anHq
         6enA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LjM566RamS9cOGWi1oxYwh/ACQIKEmK0YYeGg7bBlg8=;
        b=PLR2AFebcqUNff3sQstbzd4vBfsDwKOCBQbx7fGaXYK+elSIR67BOsD9qZVCT0NoQm
         qY5+IwCwHrib6Dm/7rd+m17rEfKFYGeGoYte4rg8+XoaWxa9dw5RR/o3jvQUNgKZSLsL
         v1R/Ws0P7KqjDp43jkPvti27/bNOTB+nJHox4fWnPk94NOyGSn/gEiKVg8nvZ672/idQ
         BHITxrthX0XvmGsTU4oR0JrMvK5cPX7Ub00tM3abrlpGbvdBAwhHauFt61B+/nplwBvK
         5Cy3DoNEaQg+92+hTMAzWQ/Goc0y4dI2IvNRRE30BbqwDlnFjVAg2ydQhLV+MdPpCn21
         4Phw==
X-Gm-Message-State: AGi0PuZmzbyo1RDdwN5ZxVlCfGPqhdBTHm0BIYV1ZoGTl+SyGn9qwsxb
        QnE+nmuB2iZCl824dS+6tQGBSAj6lpvjfiFZwnI9vfl7pC3Xbw33
X-Google-Smtp-Source: APiQypK7NQASCQne8gFxa3KTHf4eupDKh8C27Cw3rF9MoWW/Tz/bK0SO53B1iTUNow2rqHHHHKCTA+wlgmvoq9TH26E=
X-Received: by 2002:a05:6214:16c8:: with SMTP id d8mr120336qvz.93.1587129861640;
 Fri, 17 Apr 2020 06:24:21 -0700 (PDT)
MIME-Version: 1.0
From:   sam hao <ssesamhao@gmail.com>
Date:   Fri, 17 Apr 2020 21:24:10 +0800
Message-ID: <CANhq1J6AJvkXUVZtbYgZubepU8xL88Q56UrcDprmG_eDapmXtA@mail.gmail.com>
Subject: Slab-of-out-bounds in search_memslots() in kvm_host.h
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I've found possible out of bounds access in search_memslots() in kvm_host.h.
In search_memslots(struct kvm_memslots *slots, gfn_t gfn),  a binary
search is used  for slot searching,  as following code shows
        while (start < end) {
                slot = start + (end - start) / 2;

                if (gfn >= memslots[slot].base_gfn)
                        end = slot;
                else
                        start = slot + 1;
        }

        if (gfn >= memslots[start].base_gfn &&
            gfn < memslots[start].base_gfn + memslots[start].npages) {
                atomic_set(&slots->lru_slot, start);
                return &memslots[start];
        }

However, start may equal to slots->used_slots  when gfn is smaller
than every base_gfn, which cause out of bound access in  if condition.
Following code can trigger this bug:

#include <stdint.h>
#include <unistd.h>
#include <linux/kvm.h>
#include <asm/kvm.h>
#include <sys/ioctl.h>
#include <fcntl.h>

int main(int argc, char **agrv){

        struct kvm_userspace_memory_region kvm_userspace_memory_region_0 = {
                .slot = 4098152658,
                .flags = 1653871800,
                .guest_phys_addr = 9228163640593578308,
                .memory_size = 13154652985641659684,
                .userspace_addr = 2934507574655831761
        };
        char *s_0 = "/dev/kvm";
        struct kvm_vapic_addr kvm_vapic_addr_1 = {
                .vapic_addr=4096
        };

        int32_t r0 = open(s_0,0,0);
        int32_t r1 = ioctl(r0,44545,0);
        ioctl(r1,44640);
        ioctl(r1,1075883590,&kvm_userspace_memory_region_0);
        int32_t r2 = ioctl(r1,44609,0);
        ioctl(r2,44672,0);
        ioctl(r2,1074310803,&kvm_vapic_addr_1);
        return 0;
}

Consider adding a bound-check in if-condition as following code :

if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
            gfn < memslots[start].base_gfn + memslots[start].npages) {
                atomic_set(&slots->lru_slot, start);
                return &memslots[start];
}

-- 
Hao Sun
