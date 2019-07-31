Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7B57CAA4
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 19:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfGaRhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 13:37:10 -0400
Received: from foss.arm.com ([217.140.110.172]:52508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfGaRhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 13:37:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4448515A2;
        Wed, 31 Jul 2019 10:37:09 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92E5A3F71F;
        Wed, 31 Jul 2019 10:37:06 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Andrew Murray <andrew.murray@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 3/5] KVM: arm: vgic-v3: Mark expected switch fall-through
Date:   Wed, 31 Jul 2019 18:36:48 +0100
Message-Id: <20190731173650.12627-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731173650.12627-1-maz@kernel.org>
References: <20190731173650.12627-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

When fall-through warnings was enabled by default the following warnings
was starting to show up:

../virt/kvm/arm/hyp/vgic-v3-sr.c: In function ‘__vgic_v3_save_aprs’:
../virt/kvm/arm/hyp/vgic-v3-sr.c:351:24: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
   cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
../virt/kvm/arm/hyp/vgic-v3-sr.c:352:2: note: here
  case 6:
  ^~~~
../virt/kvm/arm/hyp/vgic-v3-sr.c:353:24: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
   cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
../virt/kvm/arm/hyp/vgic-v3-sr.c:354:2: note: here
  default:
  ^~~~~~~

Rework so that the compiler doesn't warn about fall-through.

Fixes: d93512ef0f0e ("Makefile: Globally enable fall-through warning")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 254c5f190a3d..ccf1fde9836c 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -349,8 +349,10 @@ void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
 	case 7:
 		cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
 		cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
+		/* Fall through */
 	case 6:
 		cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
+		/* Fall through */
 	default:
 		cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
 	}
@@ -359,8 +361,10 @@ void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
 	case 7:
 		cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
 		cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
+		/* Fall through */
 	case 6:
 		cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
+		/* Fall through */
 	default:
 		cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
 	}
@@ -382,8 +386,10 @@ void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
 	case 7:
 		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
 		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
+		/* Fall through */
 	case 6:
 		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
+		/* Fall through */
 	default:
 		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
 	}
@@ -392,8 +398,10 @@ void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
 	case 7:
 		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
 		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
+		/* Fall through */
 	case 6:
 		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
+		/* Fall through */
 	default:
 		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
 	}
-- 
2.20.1

