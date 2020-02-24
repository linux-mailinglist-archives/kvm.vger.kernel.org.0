Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FEA16AAEE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 17:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgBXQKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 11:10:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36338 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728031AbgBXQKz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 11:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582560653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GUN7E8uNuAW1Kbn7TsNWpzUqCroekYM2b6TqEf2CkXM=;
        b=ZCqwpGdRcdqis2MZENvwJP0EPozGXC9oFlAgtrdXMErSMeC2xV5UntP0vZBnfJASwBbEuz
        gCMmO5jiF65kADAq6W3OVav+h/j3JHlXKWonmOVRBWiGwrkZn4jMDhfQBf7KIrq3K7Nuwq
        +QI70QuPA3XKIdFhGorFuFNiPBNAgfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-1rjv36JnOA-QYWqKQr30uA-1; Mon, 24 Feb 2020 11:10:52 -0500
X-MC-Unique: 1rjv36JnOA-QYWqKQr30uA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 484A2800D5B
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 16:10:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64E4A8B755;
        Mon, 24 Feb 2020 16:10:50 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] KVM: selftests: Fix unknown ucall command asserts
Date:   Mon, 24 Feb 2020 17:10:49 +0100
Message-Id: <20200224161049.18545-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TEST_ASSERT in x86_64/platform_info_test.c would have print 'ucall'
instead of 'uc.cmd'. Also fix all uc.cmd format types.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c       | 2 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c                | 2 +-
 tools/testing/selftests/kvm/x86_64/platform_info_test.c        | 3 +--
 tools/testing/selftests/kvm/x86_64/state_test.c                | 2 +-
 .../testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c        | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c       | 2 +-
 7 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/t=
ools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 63cc9c3f5ab6..003d1422705a 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -106,7 +106,7 @@ int main(int argc, char *argv[])
 		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
 		}
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/test=
ing/selftests/kvm/x86_64/evmcs_test.c
index 92915e6408e7..185226c39c03 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -117,7 +117,7 @@ int main(int argc, char *argv[])
 		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
 		}
=20
 		/* UCALL_SYNC is handled here.  */
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/to=
ols/testing/selftests/kvm/x86_64/platform_info_test.c
index f9334bd3cce9..54a960ff63aa 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -58,8 +58,7 @@ static void test_msr_platform_info_enabled(struct kvm_v=
m *vm)
 			exit_reason_str(run->exit_reason));
 	get_ucall(vm, VCPU_ID, &uc);
 	TEST_ASSERT(uc.cmd =3D=3D UCALL_SYNC,
-			"Received ucall other than UCALL_SYNC: %u\n",
-			ucall);
+			"Received ucall other than UCALL_SYNC: %lu\n", uc.cmd);
 	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) =3D=3D
 		MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
 		"Expected MSR_PLATFORM_INFO to have max turbo ratio mask: %i.",
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/test=
ing/selftests/kvm/x86_64/state_test.c
index 9d2daffd6110..164774206170 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -160,7 +160,7 @@ int main(int argc, char *argv[])
 		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
 		}
=20
 		/* UCALL_SYNC is handled here.  */
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_te=
st.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index 5dfb53546a26..cc17a3d67e1f 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -81,7 +81,7 @@ int main(int argc, char *argv[])
 			TEST_ASSERT(false, "%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
 		default:
-			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
 		}
 	}
 }
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/to=
ols/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index a223a6401258..fe0734d9ef75 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -152,7 +152,7 @@ int main(int argc, char *argv[])
 			done =3D true;
 			break;
 		default:
-			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
 		}
 	}
 }
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/t=
ools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 64f7cb81f28d..5f46ffeedbf0 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -158,7 +158,7 @@ int main(int argc, char *argv[])
 		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
 		}
 	}
=20
--=20
2.21.1

