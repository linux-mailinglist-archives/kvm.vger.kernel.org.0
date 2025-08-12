Return-Path: <kvm+bounces-54554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E02B23AC4
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 23:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7779F18916AF
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 21:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D434B2D12E1;
	Tue, 12 Aug 2025 21:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yXaZO/Uo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EA022B8D9
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755034304; cv=none; b=N5iSgX0vNUY72vi2+WRaVhwaCcNk2rqvLNeAyMMymMv7csoVgbIRuw51x9wJp+16IPYIZ3eF2ZaWY7/A1PXHrx3vJufi/gAslgWyn21lopdIxcxTt0Z48l5+d5fLrgiLrEgRZt3/7JjQnkJQSdAEV1P3lNpkZCcoaTWaCqIVFto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755034304; c=relaxed/simple;
	bh=enFAnsuBI7tzmg+XmneTDUq3ne1AMj8+s7skBIKgsMQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M+6uk+9cWdvTavmhb5QqekND31Ra4TIUBpsHsjZ0uCTEP61EB8NMkrslWRw8cdGGwQOiCBA56RX/4LjyxfiOmQyyLvDOKddXQhbbwt4dKdNf3BrlCO7M1TtkMzdJ50wi0Z4oV4WTDrXj2xGxXjjfPEhsIW1aD6Um4wFZG6yClP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yXaZO/Uo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2424aaa9840so64669545ad.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 14:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755034302; x=1755639102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LmQ7nvxSibxmUYTy/1bFPxOn10Uk+OIUVnbImlldc88=;
        b=yXaZO/UoET62Iuf2ZYzjcUnivma017SEysZaunvi5McG1tjlYtOxTS02Wxxq1CRwGD
         PBaj/qNcARKX1of6jzxeUg00paxv5wVTCIGaMOfeha6PTtQt92flHKXqJIorMZKD8o24
         7d2PAb+LYqyxLFX4Va4HmCSHAfoD8NC1kt5K20z/h4cfVTGMscMTbh1q6vfngSk+Td+L
         G4b3FtWX7rZeoRfv27TFq70djLxkHOLEuBIKR9ydlbafBeQOoTST5M9oZxWlhU4eZaAS
         EXg+LC1lUtWKTiVPp+ADDDStBcTqtqOCoFpo/lL5t51x16+7lOPPy9SAs215ICRWFQ9t
         aQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755034302; x=1755639102;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LmQ7nvxSibxmUYTy/1bFPxOn10Uk+OIUVnbImlldc88=;
        b=mo8qZZ3nHvYlwhF83x80JxHBzvX7gC1rj5ulk/ZIKSYmrSpQImUqK53p8tXKfc/Ylx
         IPAbE8p1DKYodpUcwqcMPSAX6E+R2KYIiYLL/lBAhaBwlcVwlhLm/J5wJK6+e/4ODkH9
         poPkWrvsWTfPWS5Iq9k3Cq/aGDh0PT7G2dPmHbJu8ZZgfGVeTlH9tX/n9/QJ3zH27ypE
         GONsyQfZEeTz1SIS3p+6Q3LfB1p2eSo2s+DAZvhvYf16FyS53WjOE1rI+oRVDLOIYqQa
         yYrKj9k2c4442Xp1AsPF8b/ACNR9sgyDdC1eS+dcgak9Drx7+EMRHZB5KSjhBGmVe+CT
         GNEQ==
X-Gm-Message-State: AOJu0YzaSm9wCQJPEOAx3HfVuk/6Lv/rRkCbk+C+dXZ1+nbhKlXQJigE
	0HNntVuoGChNczbd1iUuNCtp60tUA46QGW3b4pxoRYTSws4xgxMhflu5rlywTed4PUMQ7vo4fBl
	Zaa0AfQ==
X-Google-Smtp-Source: AGHT+IHViKr/WTmLaVxvva9jhkIu5PG322nOf87K7N2XTyh0J1XIA4uCdArN8R4zYi5HUXl83HRkSTciuUM=
X-Received: from pghm11.prod.google.com ([2002:a63:f60b:0:b0:b42:2386:7609])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e78c:b0:235:6aa:1675
 with SMTP id d9443c01a7336-2430d23f276mr9439865ad.52.1755034302080; Tue, 12
 Aug 2025 14:31:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Aug 2025 14:31:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812213133.161300-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.08.13 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled for tomorrow as I won't be able to join.  My apologies for the
late notice.

