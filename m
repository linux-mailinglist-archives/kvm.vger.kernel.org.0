Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7E5F9AE
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfGDOHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:07:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35533 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfGDOHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:07:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id c27so6811450wrb.2;
        Thu, 04 Jul 2019 07:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MvfpCcwP28+TBmBj1O3oyBlPKHN+Je1C3rbxB2DoDSc=;
        b=A2is8hAeYQZz0wjbz2Th3XTbRIeoNaAluBRG0B2DSDo0JEXXhGAboJ9m7jqJlBLUan
         xhgtxN0HVVlDwB857d2rVSH7nDSeEBx6eHV5U3K8vavHXgerjwjlXS0fIVSNOcX+UA5J
         NtJENYskL9ixZbIuwjEURe4wPm71OqgMHri5p+krUpHxw37diSAFzax4s9ebntrWUWdC
         V+xlObHRnvp9L3xlVAgp1GRvdKCCPDeIgGBp0DBJaQJFWRv8lDzfJYx8uLtKGcYWV379
         MfrIW65N7rcMCq1P5f+GURCoT79OjPob0zbAdP5ww94+nhTM82BGcQe/C8saiS/CDtzy
         oJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=MvfpCcwP28+TBmBj1O3oyBlPKHN+Je1C3rbxB2DoDSc=;
        b=H7mxLL6A092I5WmXtVdYuALlEXGWtsrOS1ASicEqwvV4BbKkGnh90iKhHpqYO7NdV/
         lAn/MJe0pHxKBMFSeEShlN76iHWxmQ/bojY9WFwFhSUftCa4wSW/GqxKPmmfH+9zT2sL
         CY7RWo2QHrJak1IrKD2l4EfnxobOEIaykeIykzR28wuHAEWQmP9MpcHYvdaMVzCpL3lv
         JvhE6UrMS9FZy7l7zeRaT2oddGHXY81TzybxOIl6pWK6CJuMj9fSsoUx4J9/jesn2aNq
         uPjxiND/uaVsdsrKniHoN0jMS9gZgClCypwKZxX5MqSA2uwWYiMer4yzb9bm+ECMbBPa
         U4AA==
X-Gm-Message-State: APjAAAW0Z/SgBaZFDmmsakk7M4V4BAvEG4hNi29a2nZa3p2iB7ddRkxg
        52gLN3fia6lHzYRxlJptL115bfnd0cI=
X-Google-Smtp-Source: APXvYqxk/4aVoqyEb13bwLt2Cf1DTcN4wHc6o3km4sCHW9KFJH3uv9xMvDiD2XtNYSuVvqcDqgtjmw==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr3492555wrw.185.1562249237169;
        Thu, 04 Jul 2019 07:07:17 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n5sm4458060wmi.21.2019.07.04.07.07.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:07:16 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jing2.liu@linux.intel.com
Subject: [PATCH 0/5] KVM: cpuid: cleanups, simplify multi-index CPUID leaves
Date:   Thu,  4 Jul 2019 16:07:10 +0200
Message-Id: <20190704140715.31181-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While reviewing the AVX512_BF16, Jing Liu and I noted that the handling of
CPUID leaf 7 is quite messy, and in general the handling of multi-index
CPUID leaves is confusing.  These patches clean the code to prepare
for adding CPUID leaf 7 subleaf 1.

Paolo Bonzini (5):
  KVM: cpuid: do_cpuid_ent works on a whole CPUID function
  KVM: cpuid: extract do_cpuid_7_mask and support multiple subleafs
  KVM: cpuid: set struct kvm_cpuid_entry2 flags in do_cpuid_1_ent
  KVM: cpuid: rename do_cpuid_1_ent
  KVM: cpuid: remove has_leaf_count from struct kvm_cpuid_param

 arch/x86/kvm/cpuid.c | 222 ++++++++++++++++++++++++-------------------
 1 file changed, 122 insertions(+), 100 deletions(-)

-- 
2.21.0

